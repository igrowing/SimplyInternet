import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simply_internet/features/urlcheck/data/repositories/url_inspector_impl.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';

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

/// An inspector whose every request is answered by [handler].
UrlInspectorImpl inspector(
  Future<http.Response> Function(http.Request) handler,
) => UrlInspectorImpl(clientFactory: () => MockClient(handler));

/// An inspector whose every request throws [error] instead of answering, so the
/// transport failures each method must swallow can be driven one at a time.
UrlInspectorImpl inspectorThrowing(Exception error) =>
    UrlInspectorImpl(clientFactory: () => MockClient((_) async => throw error));

final _example = Uri.parse('https://example.com');

/// Every transport failure the inspector is written to absorb. Each one must
/// produce an explicit "unavailable" fact rather than escaping to the caller.
final _transportFailures = <String, Exception>{
  'a timeout': TimeoutException('too slow'),
  'a client error': http.ClientException('connection closed'),
  'a socket error': const SocketException('refused'),
};

void main() {
  group('UrlInspectorImpl.fetch reads Retry-After', () {
    test('as a number of seconds', () async {
      final result = await inspectorAnswering('90').fetch(_example);
      expect(result.statusCode, 429);
      expect(result.retryAfterSeconds, 90);
    });

    test('as an HTTP date, converted to a wait from now', () async {
      final when = DateTime.now().toUtc().add(const Duration(minutes: 5));
      final result = await inspectorAnswering(
        HttpDate.format(when),
      ).fetch(_example);
      expect(result.retryAfterSeconds, closeTo(300, 5));
    });

    test('and reports nothing when the header is absent or junk', () async {
      final missing = await inspectorAnswering(null).fetch(_example);
      final junk = await inspectorAnswering('soon-ish').fetch(_example);
      final past = await inspectorAnswering('-5').fetch(_example);
      expect(missing.retryAfterSeconds, isNull);
      expect(junk.retryAfterSeconds, isNull);
      expect(past.retryAfterSeconds, isNull);
    });

    test('and reports nothing for an HTTP date already gone by', () async {
      // The server is telling us the wait is over, not asking for another one.
      final past = DateTime.now().toUtc().subtract(const Duration(minutes: 5));
      final result = await inspectorAnswering(
        HttpDate.format(past),
      ).fetch(_example);
      expect(result.retryAfterSeconds, isNull);
    });

    test('and ignores an empty or blank header', () async {
      final empty = await inspectorAnswering('').fetch(_example);
      final blank = await inspectorAnswering('   ').fetch(_example);
      expect(empty.retryAfterSeconds, isNull);
      expect(blank.retryAfterSeconds, isNull);
    });
  });

  group('UrlInspectorImpl.fetch', () {
    test('reports the status, the landing URL and the round trip', () async {
      final result = await inspector(
        (request) async => http.Response('hi', 200, request: request),
      ).fetch(_example);

      expect(result.reached, isTrue);
      expect(result.statusCode, 200);
      expect(result.isSuccess, isTrue);
      expect(result.finalUrl, 'https://example.com');
      expect(result.elapsedMs, isNotNull);
      expect(result.elapsedMs, greaterThanOrEqualTo(0));
      expect(result.error, isNull);
    });

    test('falls back to the requested URL when none is named', () async {
      final result = await inspector(
        (_) async => http.Response('hi', 200),
      ).fetch(Uri.parse('https://example.com/page'));
      expect(result.finalUrl, 'https://example.com/page');
    });

    test('turns a timeout into a plain reason', () async {
      final result = await inspectorThrowing(
        TimeoutException('too slow'),
      ).fetch(_example);
      expect(result.reached, isFalse);
      expect(result.error, 'timed out');
      expect(result.statusCode, isNull);
    });

    test('keeps the client error message', () async {
      final result = await inspectorThrowing(
        http.ClientException('connection closed before full header'),
      ).fetch(_example);
      expect(result.reached, isFalse);
      expect(result.error, 'connection closed before full header');
    });

    test('keeps the OS message from a socket failure', () async {
      final result = await inspectorThrowing(
        const SocketException(
          'failed',
          osError: OSError('Connection refused', 111),
        ),
      ).fetch(_example);
      expect(result.error, 'Connection refused');
    });

    test('names a socket failure that carries no OS message', () async {
      final result = await inspectorThrowing(
        const SocketException('failed'),
      ).fetch(_example);
      expect(result.error, 'connection failed');
    });

    test('names a TLS handshake failure as such', () async {
      // "Connection failed" would send the user chasing their router when the
      // problem is the site's certificate.
      final result = await inspectorThrowing(
        const HandshakeException('bad cert'),
      ).fetch(_example);
      expect(result.reached, isFalse);
      expect(result.error, 'TLS handshake failed');
    });
  });

  group('UrlInspectorImpl.domainInfo', () {
    /// An RDAP body whose expiry event is [expiry].
    String rdapBody(String expiry) => jsonEncode({
      'objectClassName': 'domain',
      'events': [
        {'eventAction': 'registration', 'eventDate': '2001-01-01T00:00:00Z'},
        {'eventAction': 'expiration', 'eventDate': expiry},
      ],
    });

    test('asks rdap.org for the domain it was given', () async {
      Uri? asked;
      await inspector((request) async {
        asked = request.url;
        return http.Response('{}', 200);
      }).domainInfo('example.com');
      expect(asked.toString(), 'https://rdap.org/domain/example.com');
    });

    test('a 404 means the registry checked and has no such domain', () async {
      final info = await inspector(
        (_) async => http.Response('not found', 404),
      ).domainInfo('nope.example');
      expect(info.checked, isTrue);
      expect(info.exists, isFalse);
      expect(info.expired, isFalse);
    });

    test('any other error status leaves the domain unknown', () async {
      for (final code in [403, 429, 500, 503]) {
        final info = await inspector(
          (_) async => http.Response('nope', code),
        ).domainInfo('example.com');
        expect(info, const DomainInfo.unavailable(), reason: '$code');
      }
    });

    test('reads the registration expiry', () async {
      final future = DateTime.now().toUtc().add(const Duration(days: 200));
      final info = await inspector(
        (_) async => http.Response(rdapBody(future.toIso8601String()), 200),
      ).domainInfo('example.com');

      expect(info.checked, isTrue);
      expect(info.exists, isTrue);
      expect(info.expired, isFalse);
      expect(info.expiry, isNotNull);
      expect(info.expiry!.difference(future).inMinutes, 0);
    });

    test('flags a registration whose date has passed', () async {
      // An expired registration is the difference between "the site is broken"
      // and "the owner forgot to renew", which the user can act on.
      final past = DateTime.now().toUtc().subtract(const Duration(days: 3));
      final info = await inspector(
        (_) async => http.Response(rdapBody(past.toIso8601String()), 200),
      ).domainInfo('example.com');

      expect(info.exists, isTrue);
      expect(info.expired, isTrue);
    });

    test('records the domain as existing when no expiry is given', () async {
      for (final body in <String>[
        jsonEncode({'objectClassName': 'domain'}),
        jsonEncode({'events': 'not a list'}),
        jsonEncode({
          'events': [
            'not a map',
            {'eventAction': 'registration', 'eventDate': '2001-01-01T00:00Z'},
            {'eventAction': 'expiration', 'eventDate': 42},
          ],
        }),
        jsonEncode({
          'events': [
            {'eventAction': 'expiration', 'eventDate': 'the twelfth of never'},
          ],
        }),
      ]) {
        final info = await inspector(
          (_) async => http.Response(body, 200),
        ).domainInfo('example.com');
        expect(info.exists, isTrue, reason: body);
        expect(info.expiry, isNull, reason: body);
        expect(info.expired, isFalse, reason: body);
      }
    });

    test('a body that is not an object tells us nothing', () async {
      for (final body in <String>['[1,2,3]', '"a string"', 'null', '7']) {
        final info = await inspector(
          (_) async => http.Response(body, 200),
        ).domainInfo('example.com');
        expect(info, const DomainInfo.unavailable(), reason: body);
      }
    });

    test('a body that is not JSON tells us nothing', () async {
      final info = await inspector(
        (_) async => http.Response('<html>oops</html>', 200),
      ).domainInfo('example.com');
      expect(info, const DomainInfo.unavailable());
    });

    for (final failure in _transportFailures.entries) {
      test('${failure.key} leaves the domain unknown', () async {
        final info = await inspectorThrowing(
          failure.value,
        ).domainInfo('example.com');
        expect(info, const DomainInfo.unavailable());
      });
    }
  });

  group('UrlInspectorImpl.checkFromRegions', () {
    /// Answers the start request with [nodes] and every poll with [result].
    UrlInspectorImpl regionService({
      required Object startBody,
      int startStatus = 200,
      Object? resultBody,
      int resultStatus = 200,
    }) => inspector((request) async {
      if (request.url.path.contains('check-result')) {
        return http.Response(
          resultBody is String ? resultBody : jsonEncode(resultBody),
          resultStatus,
        );
      }
      return http.Response(
        startBody is String ? startBody : jsonEncode(startBody),
        startStatus,
      );
    });

    test('sends the URL to check-host and summarises the answers', () async {
      final report = await regionService(
        startBody: {
          'request_id': 'abc123',
          'nodes': {
            'us1.node.check-host.net': ['us', 'North America', 'Dallas'],
            'de1.node.check-host.net': ['de', 'Europe', 'Frankfurt'],
            'fr1.node.check-host.net': ['fr', 'Europe', 'Paris'],
            'weird.node': 'not a list',
          },
        },
        resultBody: {
          'us1.node.check-host.net': [
            [1, 0.42, 'OK'],
          ],
          'de1.node.check-host.net': [
            [0, 0.0, 'Timeout'],
          ],
          'fr1.node.check-host.net': [
            [0, 0.0, 'Timeout'],
          ],
          // A node whose shape we do not understand is skipped rather than
          // counted as a failure and blamed on the site.
          'weird.node': 'nonsense',
          'empty.node': <Object>[],
          'emptyfirst.node': [<Object>[]],
        },
      ).checkFromRegions(_example);

      expect(report.available, isTrue);
      expect(report.total, 3);
      expect(report.reachable, 1);
      expect(report.reachableFromSome, isTrue);
      expect(report.reachableFromAll, isFalse);
      // Country codes, upper-cased and sorted so the list reads the same way
      // every run.
      expect(report.blockedCountries, ['DE', 'FR']);
      expect(
        report.probes.map((p) => '${p.location}:${p.reachable}'),
        ['US:true', 'DE:false', 'FR:false'],
      );
    });

    test('names a node by its own id when the country is unknown', () async {
      final report = await regionService(
        startBody: {
          'request_id': 'abc123',
          'nodes': {
            'zz1.node.check-host.net': <Object>[],
          },
        },
        resultBody: {
          'zz1.node.check-host.net': [
            [1, 0.1, 'OK'],
          ],
        },
      ).checkFromRegions(_example);

      expect(report.probes.single.location, 'zz1.node.check-host.net');
      expect(report.blockedCountries, isEmpty);
    });

    test('gives up when the service never returns usable results', () async {
      // Five polls that answer nothing we can read: better to say the check was
      // unavailable than to invent a verdict from it.
      final report = await regionService(
        startBody: {
          'request_id': 'abc123',
          'nodes': {
            'us1.node': ['us'],
          },
        },
        resultBody: 'not json at all',
        resultStatus: 500,
      ).checkFromRegions(_example);

      expect(report, const RegionReport.unavailable());
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('reports nothing when the start request is refused', () async {
      final report = await regionService(
        startBody: 'busy',
        startStatus: 429,
      ).checkFromRegions(_example);
      expect(report, const RegionReport.unavailable());
    });

    test('reports nothing when the start answer makes no sense', () async {
      for (final body in <Object>[
        '[1,2,3]',
        'not json',
        {'nodes': <String, Object>{}}, // no request id
        {'request_id': 42, 'nodes': <String, Object>{}}, // id is not a string
        {'request_id': 'abc', 'nodes': 'not a map'},
      ]) {
        final report = await regionService(
          startBody: body,
        ).checkFromRegions(_example);
        expect(report, const RegionReport.unavailable(), reason: '$body');
      }
    });

    test('reports nothing when no node produced a usable row', () async {
      final report = await regionService(
        startBody: {
          'request_id': 'abc123',
          'nodes': {
            'us1.node': ['us'],
          },
        },
        resultBody: {'us1.node': 'nonsense'},
      ).checkFromRegions(_example);
      expect(report, const RegionReport.unavailable());
    });

    for (final failure in _transportFailures.entries) {
      test('${failure.key} leaves the region check unavailable', () async {
        final report = await inspectorThrowing(
          failure.value,
        ).checkFromRegions(_example);
        expect(report, const RegionReport.unavailable());
      });
    }
  });

  group('UrlInspectorImpl.crossCheckOutage', () {
    UrlInspectorImpl outageService(Object body, {int status = 200}) =>
        inspector(
          (_) async => http.Response(
            body is String ? body : jsonEncode(body),
            status,
          ),
        );

    test('asks the service about the host, not the whole URL', () async {
      Uri? asked;
      await inspector((request) async {
        asked = request.url;
        return http.Response('{}', 200);
      }).crossCheckOutage(Uri.parse('https://example.com/deep/page?q=1'));
      expect(asked!.queryParameters['url'], 'example.com');
    });

    test('reads the verdict, the counts and the regions', () async {
      final report = await outageService({
        'ok': true,
        'isUp': false,
        'verdict': 'partial',
        'summary': 'Reachable from some places only.',
        'signalCounts': {'total': 6, 'up': 2, 'likelyBlocked': 4},
        'alternateHost': {'hostname': 'www.example.com', 'verdict': 'up'},
        'regions': [
          {
            'region': {'label': 'Europe'},
            'isUp': true,
            'status': 200,
          },
          {
            'region': {'label': 'Asia'},
            'isUp': false,
            'status': 403,
          },
        ],
      }).crossCheckOutage(_example);

      expect(report.available, isTrue);
      expect(report.isUp, isFalse);
      expect(report.verdict, 'partial');
      expect(report.summary, 'Reachable from some places only.');
      expect(report.total, 6);
      expect(report.up, 2);
      expect(report.likelyBlocked, 4);
      expect(report.alternateHost, 'www.example.com');
      expect(report.alternateHostUp, isTrue);
      expect(report.source, 'websitedown.org');
      expect(
        report.probes.map((p) => '${p.location}/${p.reachable}/${p.statusCode}'),
        ['Europe/true/200', 'Asia/false/403'],
      );
    });

    test('accepts counts that arrive as decimals', () async {
      final report = await outageService({
        'ok': true,
        'signalCounts': {'total': 6.0, 'up': 6.0, 'likelyBlocked': 0.0},
      }).crossCheckOutage(_example);
      expect(report.total, 6);
      expect(report.up, 6);
      expect(report.upEverywhere, isTrue);
    });

    test('treats unreadable counts as zero rather than guessing', () async {
      final report = await outageService({
        'ok': true,
        'signalCounts': {'total': 4, 'up': 'lots', 'likelyBlocked': null},
      }).crossCheckOutage(_example);
      expect(report.total, 4);
      expect(report.up, 0);
      expect(report.likelyBlocked, 0);
    });

    test('leaves out an alternate host the service did not name', () async {
      // No hostname means there is nothing to suggest, whatever else the
      // object carried; every reader of the report gates on the host being
      // present before it looks at whether that host was up.
      for (final alt in <Object?>[
        null,
        'www.example.com', // a bare string, not the object we expect
        {'verdict': 'up'}, // a verdict about a host it never names
        {'hostname': 42},
      ]) {
        final report = await outageService({
          'ok': true,
          'signalCounts': {'total': 1, 'up': 1},
          'alternateHost': alt,
        }).crossCheckOutage(_example);
        expect(report.alternateHost, isNull, reason: '$alt');
      }
    });

    test('an alternate host that is itself down is reported as down', () async {
      final report = await outageService({
        'ok': true,
        'signalCounts': {'total': 1, 'up': 0},
        'alternateHost': {'hostname': 'www.example.com', 'verdict': 'down'},
      }).crossCheckOutage(_example);
      expect(report.alternateHost, 'www.example.com');
      expect(report.alternateHostUp, isFalse);
    });

    test('keeps only the regions that name a place', () async {
      final report = await outageService({
        'ok': true,
        'signalCounts': {'total': 1, 'up': 1},
        'regions': [
          'not a map',
          {'isUp': true}, // no region at all
          {'region': 'not a map', 'isUp': true},
          {
            'region': {'code': 'eu'}, // no label
            'isUp': true,
          },
          {
            'region': {'label': 'Europe'},
            'isUp': true,
            'status': 'two hundred', // not a number: no code to show
          },
        ],
      }).crossCheckOutage(_example);

      expect(report.probes, hasLength(1));
      expect(report.probes.single.location, 'Europe');
      expect(report.probes.single.statusCode, isNull);
    });

    test('reports no regions when the service listed none', () async {
      for (final regions in <Object?>[null, 'nope', 42]) {
        final report = await outageService({
          'ok': true,
          'signalCounts': {'total': 1, 'up': 1},
          'regions': regions,
        }).crossCheckOutage(_example);
        expect(report.probes, isEmpty, reason: '$regions');
      }
    });

    test('a service that probed nothing is no second opinion', () async {
      // Zero regions cannot confirm or deny an outage, so the cross-check must
      // stand down instead of reporting a site "down everywhere" on no data.
      for (final body in <Object>[
        {'ok': true, 'signalCounts': {'total': 0, 'up': 0}},
        {'ok': true, 'signalCounts': 'not a map'},
        {'ok': true},
      ]) {
        final report = await outageService(body).crossCheckOutage(_example);
        expect(report, const OutageReport.unavailable(), reason: '$body');
      }
    });

    test('a body the service did not vouch for is discarded', () async {
      for (final body in <Object>[
        {'ok': false, 'signalCounts': {'total': 6, 'up': 6}},
        {'signalCounts': {'total': 6, 'up': 6}},
        '[1,2,3]',
        'not json',
      ]) {
        final report = await outageService(body).crossCheckOutage(_example);
        expect(report, const OutageReport.unavailable(), reason: '$body');
      }
    });

    test('a refused request is no second opinion either', () async {
      final report = await outageService(
        {'ok': true},
        status: 503,
      ).crossCheckOutage(_example);
      expect(report, const OutageReport.unavailable());
    });

    test('non-string verdict and summary fall back to empty', () async {
      final report = await outageService({
        'ok': true,
        'verdict': 42,
        'summary': null,
        'signalCounts': {'total': 1, 'up': 1},
      }).crossCheckOutage(_example);
      expect(report.verdict, '');
      expect(report.summary, '');
    });

    for (final failure in _transportFailures.entries) {
      test('${failure.key} leaves the cross-check unavailable', () async {
        final report = await inspectorThrowing(
          failure.value,
        ).crossCheckOutage(_example);
        expect(report, const OutageReport.unavailable());
      });
    }
  });

  group('UrlInspectorImpl.dnsResolves', () {
    final subject = UrlInspectorImpl();

    test('resolves a name the host itself knows', () async {
      expect(await subject.dnsResolves('localhost'), isTrue);
    });

    test('is false, never an error, for a name that cannot resolve', () async {
      // Resolution failure is a finding the report explains, so it must come
      // back as a plain false rather than escaping as an exception.
      expect(await subject.dnsResolves('..'), isFalse);
    });
  });

  group('UrlInspectorImpl.checkPorts', () {
    final subject = UrlInspectorImpl();
    late ServerSocket server;

    setUp(() async {
      server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0)
        ..listen((socket) => socket.destroy());
    });

    tearDown(() => server.close());

    test('reports an open port as open and a closed one as closed', () async {
      final closed = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final closedPort = closed.port;
      await closed.close();

      final results = await subject.checkPorts('127.0.0.1', [
        server.port,
        closedPort,
      ]);

      expect(results.map((r) => r.port), [server.port, closedPort]);
      expect(results.first.open, isTrue);
      expect(results.last.open, isFalse);
    });

    test('names the well-known services and numbers the rest', () async {
      // Probed against a closed loopback port so the names, not the network,
      // are what the test depends on.
      final results = await subject.checkPorts('127.0.0.1', [
        80,
        443,
        8080,
        8443,
        9999,
      ]);
      expect(results.map((r) => r.service), [
        'HTTP',
        'HTTPS',
        'HTTP-alt',
        'HTTPS-alt',
        'port 9999',
      ]);
    });

    test('checks nothing when asked for no ports', () async {
      expect(await subject.checkPorts('127.0.0.1', []), isEmpty);
    });
  });

  group('UrlInspectorImpl.tlsInfo', () {
    final subject = UrlInspectorImpl();

    test('a port that refuses the connection tells us nothing', () async {
      final closed = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = closed.port;
      await closed.close();

      expect(
        await subject.tlsInfo('127.0.0.1', port),
        const TlsInfo.unavailable(),
      );
    });

    test('a server that speaks no TLS is reported as untrusted', () async {
      // The handshake fails, the retry that accepts any certificate also fails
      // because there is no certificate to accept — but the check did happen,
      // so it reports a reason rather than staying silent.
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0)
        ..listen((socket) {
          socket
            ..add(utf8.encode('HTTP/1.1 400 Bad Request\r\n\r\n'))
            ..close();
        });
      addTearDown(server.close);

      final info = await subject.tlsInfo('127.0.0.1', server.port);
      expect(info.checked, isTrue);
      expect(info.valid, isFalse);
      expect(info.issue, 'certificate not trusted');
    });
  });
}
