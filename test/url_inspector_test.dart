import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simply_internet/features/urlcheck/data/repositories/url_inspector_impl.dart';

/// Builds an inspector whose fetches are answered by a canned 429 carrying
/// [retryAfter] as its `Retry-After` header.
UrlInspectorImpl inspectorAnswering(String? retryAfter) => UrlInspectorImpl(
  clientFactory: () => MockClient(
    (_) async => http.Response(
      'slow down',
      429,
      headers: {if (retryAfter != null) 'retry-after': retryAfter},
    ),
  ),
);

void main() {
  group('UrlInspectorImpl.fetch reads Retry-After', () {
    test('as a number of seconds', () async {
      final result = await inspectorAnswering(
        '90',
      ).fetch(Uri.parse('https://example.com'));
      expect(result.statusCode, 429);
      expect(result.retryAfterSeconds, 90);
    });

    test('as an HTTP date, converted to a wait from now', () async {
      final when = DateTime.now().toUtc().add(const Duration(minutes: 5));
      final result = await inspectorAnswering(
        HttpDate.format(when),
      ).fetch(Uri.parse('https://example.com'));
      expect(result.retryAfterSeconds, closeTo(300, 5));
    });

    test('and reports nothing when the header is absent or junk', () async {
      final missing = await inspectorAnswering(
        null,
      ).fetch(Uri.parse('https://example.com'));
      final junk = await inspectorAnswering(
        'soon-ish',
      ).fetch(Uri.parse('https://example.com'));
      final past = await inspectorAnswering(
        '-5',
      ).fetch(Uri.parse('https://example.com'));
      expect(missing.retryAfterSeconds, isNull);
      expect(junk.retryAfterSeconds, isNull);
      expect(past.retryAfterSeconds, isNull);
    });
  });
}
