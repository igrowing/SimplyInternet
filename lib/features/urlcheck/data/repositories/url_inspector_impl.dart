import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_inspector.dart';

/// Real [UrlInspector] built on `dart:io` sockets, the `http` client, RDAP
/// (rdap.org) for domain facts and check-host.net for multi-country probes.
/// Every method swallows its own failures and returns an explicit negative or
/// "unavailable" fact (see AGENTS.md).
class UrlInspectorImpl implements UrlInspector {
  UrlInspectorImpl({http.Client Function()? clientFactory})
    : _clientFactory = clientFactory ?? http.Client.new;

  final http.Client Function() _clientFactory;

  static const String _userAgent = 'Mozilla/5.0 (Android) SimplyInternet/1.0';

  @override
  Future<HttpFetchResult> fetch(Uri url) async {
    final client = _clientFactory();
    final sw = Stopwatch()..start();
    try {
      final response = await client
          .get(url, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 12));
      sw.stop();
      return HttpFetchResult(
        reached: true,
        statusCode: response.statusCode,
        finalUrl: response.request?.url.toString() ?? url.toString(),
        elapsedMs: sw.elapsedMilliseconds,
        retryAfterSeconds: _retryAfter(response.headers['retry-after']),
      );
    } on TimeoutException {
      return const HttpFetchResult.failed('timed out');
    } on http.ClientException catch (e) {
      return HttpFetchResult.failed(e.message);
    } on SocketException catch (e) {
      return HttpFetchResult.failed(e.osError?.message ?? 'connection failed');
    } on HandshakeException {
      return const HttpFetchResult.failed('TLS handshake failed');
    } finally {
      client.close();
    }
  }

  /// `Retry-After` comes either as a number of seconds or as an HTTP date;
  /// both are turned into seconds from now, and anything unparsable yields
  /// null rather than a guessed wait.
  static int? _retryAfter(String? header) {
    final value = header?.trim();
    if (value == null || value.isEmpty) return null;
    final seconds = int.tryParse(value);
    if (seconds != null) return seconds < 0 ? null : seconds;
    try {
      final date = HttpDate.parse(value);
      final wait = date.difference(DateTime.now()).inSeconds;
      return wait <= 0 ? null : wait;
    } on HttpException {
      // A malformed header is no information: say so instead of inventing a
      // wait the server never asked for.
      return null;
    }
  }

  @override
  Future<bool> dnsResolves(String host) async {
    try {
      final addrs = await InternetAddress.lookup(
        host,
      ).timeout(const Duration(seconds: 5));
      return addrs.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  @override
  Future<DomainInfo> domainInfo(String domain) async {
    final client = _clientFactory();
    try {
      final resp = await client
          .get(
            Uri.parse('https://rdap.org/domain/$domain'),
            headers: {
              'Accept': 'application/rdap+json',
              'User-Agent': _userAgent,
            },
          )
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode == 404) {
        return const DomainInfo(checked: true);
      }
      if (resp.statusCode != 200) {
        return const DomainInfo.unavailable();
      }
      final body = jsonDecode(resp.body);
      if (body is! Map<String, dynamic>) {
        return const DomainInfo.unavailable();
      }
      final expiry = _rdapExpiry(body['events']);
      final expired = expiry != null && expiry.isBefore(DateTime.now());
      return DomainInfo(
        checked: true,
        exists: true,
        expired: expired,
        expiry: expiry,
      );
    } on TimeoutException {
      return const DomainInfo.unavailable();
    } on http.ClientException {
      return const DomainInfo.unavailable();
    } on SocketException {
      return const DomainInfo.unavailable();
    } on FormatException {
      return const DomainInfo.unavailable();
    } finally {
      client.close();
    }
  }

  DateTime? _rdapExpiry(Object? events) {
    if (events is! List) return null;
    for (final e in events) {
      if (e is Map &&
          e['eventAction'] == 'expiration' &&
          e['eventDate'] is String) {
        return DateTime.tryParse(e['eventDate'] as String);
      }
    }
    return null;
  }

  @override
  Future<List<UrlPortResult>> checkPorts(String host, List<int> ports) async {
    final futures = ports.map((p) async {
      final open = await _tcpOpen(host, p);
      return UrlPortResult(port: p, service: _serviceName(p), open: open);
    });
    return Future.wait(futures);
  }

  String _serviceName(int port) {
    switch (port) {
      case 80:
        return 'HTTP';
      case 443:
        return 'HTTPS';
      case 8080:
        return 'HTTP-alt';
      case 8443:
        return 'HTTPS-alt';
      default:
        return 'port $port';
    }
  }

  Future<bool> _tcpOpen(String host, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 4),
      );
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } finally {
      socket?.destroy();
    }
  }

  @override
  Future<TlsInfo> tlsInfo(String host, int port) async {
    // First try a strict handshake: success means the certificate is trusted.
    try {
      final socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 6),
      );
      final cert = socket.peerCertificate;
      socket.destroy();
      return TlsInfo(checked: true, valid: true, expiry: cert?.endValidity);
    } on HandshakeException {
      // Accept the bad certificate just to read it and explain why it failed.
      return _inspectBadCertificate(host, port);
    } on SocketException {
      return const TlsInfo.unavailable();
    } on TimeoutException {
      return const TlsInfo.unavailable();
    }
  }

  Future<TlsInfo> _inspectBadCertificate(String host, int port) async {
    try {
      final socket = await SecureSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 6),
        onBadCertificate: (_) => true,
      );
      final cert = socket.peerCertificate;
      socket.destroy();
      if (cert != null && cert.endValidity.isBefore(DateTime.now())) {
        return TlsInfo(
          checked: true,
          expiry: cert.endValidity,
          issue: 'certificate expired',
        );
      }
      return TlsInfo(
        checked: true,
        expiry: cert?.endValidity,
        issue: 'certificate not trusted (wrong name or unknown issuer)',
      );
    } on SocketException {
      return const TlsInfo(checked: true, issue: 'certificate not trusted');
    } on TimeoutException {
      return const TlsInfo.unavailable();
    } on HandshakeException {
      return const TlsInfo(checked: true, issue: 'certificate not trusted');
    }
  }

  @override
  Future<RegionReport> checkFromRegions(Uri url) async {
    final client = _clientFactory();
    try {
      final start = await client
          .get(
            Uri.parse(
              'https://check-host.net/check-http'
              '?host=${Uri.encodeQueryComponent(url.toString())}&max_nodes=12',
            ),
            headers: {'Accept': 'application/json', 'User-Agent': _userAgent},
          )
          .timeout(const Duration(seconds: 8));
      if (start.statusCode != 200) return const RegionReport.unavailable();
      final started = jsonDecode(start.body);
      if (started is! Map<String, dynamic>) {
        return const RegionReport.unavailable();
      }
      final requestId = started['request_id'];
      final nodes = started['nodes'];
      if (requestId is! String || nodes is! Map<String, dynamic>) {
        return const RegionReport.unavailable();
      }
      final countryByNode = <String, String>{};
      nodes.forEach((node, info) {
        if (info is List && info.isNotEmpty && info[0] is String) {
          countryByNode[node] = (info[0] as String).toUpperCase();
        }
      });
      // Must await here: returning the future directly would let the
      // `finally` below close the client before polling finishes.
      return await _pollRegionResult(client, requestId, countryByNode);
    } on TimeoutException {
      return const RegionReport.unavailable();
    } on http.ClientException {
      return const RegionReport.unavailable();
    } on SocketException {
      return const RegionReport.unavailable();
    } on FormatException {
      return const RegionReport.unavailable();
    } finally {
      client.close();
    }
  }

  Future<RegionReport> _pollRegionResult(
    http.Client client,
    String requestId,
    Map<String, String> countryByNode,
  ) async {
    final resultUri = Uri.parse(
      'https://check-host.net/check-result/$requestId',
    );
    for (var attempt = 0; attempt < 5; attempt++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final resp = await client
          .get(
            resultUri,
            headers: {'Accept': 'application/json', 'User-Agent': _userAgent},
          )
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) continue;
      final data = jsonDecode(resp.body);
      if (data is! Map<String, dynamic>) continue;
      final pending = data.values.any((v) => v == null);
      if (!pending || attempt == 4) {
        return _summariseRegions(data, countryByNode);
      }
    }
    return const RegionReport.unavailable();
  }

  @override
  Future<OutageReport> crossCheckOutage(Uri url) async {
    final client = _clientFactory();
    try {
      final resp = await client
          .get(
            Uri.parse(
              'https://websitedown.org/api/v1/check'
              '?url=${Uri.encodeQueryComponent(url.host)}',
            ),
            headers: {'Accept': 'application/json', 'User-Agent': _userAgent},
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return const OutageReport.unavailable();
      final body = jsonDecode(resp.body);
      if (body is! Map<String, dynamic> || body['ok'] != true) {
        return const OutageReport.unavailable();
      }
      final counts = body['signalCounts'];
      final total = counts is Map ? _asInt(counts['total']) : 0;
      if (total == 0) return const OutageReport.unavailable();
      final alt = body['alternateHost'];
      return OutageReport(
        probes: _outageProbes(body['regions']),
        available: true,
        isUp: body['isUp'] == true,
        verdict: body['verdict'] is String ? body['verdict'] as String : '',
        summary: body['summary'] is String ? body['summary'] as String : '',
        total: total,
        up: counts is Map ? _asInt(counts['up']) : 0,
        likelyBlocked: counts is Map ? _asInt(counts['likelyBlocked']) : 0,
        alternateHost: alt is Map && alt['hostname'] is String
            ? alt['hostname'] as String
            : null,
        alternateHostUp: alt is Map && alt['verdict'] == 'up',
      );
    } on TimeoutException {
      return const OutageReport.unavailable();
    } on http.ClientException {
      return const OutageReport.unavailable();
    } on SocketException {
      return const OutageReport.unavailable();
    } on FormatException {
      return const OutageReport.unavailable();
    } finally {
      client.close();
    }
  }

  /// Per-region results from the outage service, so the report can list which
  /// continents were tested and what each one saw.
  List<RegionProbe> _outageProbes(Object? regions) {
    if (regions is! List) return const [];
    final out = <RegionProbe>[];
    for (final entry in regions) {
      if (entry is! Map) continue;
      final region = entry['region'];
      final label = region is Map && region['label'] is String
          ? region['label'] as String
          : null;
      if (label == null) continue;
      final status = entry['status'];
      out.add(
        RegionProbe(
          location: label,
          reachable: entry['isUp'] == true,
          statusCode: status is int ? status : null,
        ),
      );
    }
    return out;
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  RegionReport _summariseRegions(
    Map<String, dynamic> data,
    Map<String, String> countryByNode,
  ) {
    var total = 0;
    var reachable = 0;
    final blocked = <String>{};
    final probes = <RegionProbe>[];
    data.forEach((node, value) {
      if (value is! List || value.isEmpty) return;
      final first = value[0];
      if (first is! List || first.isEmpty) return;
      total++;
      final ok = first[0] == 1;
      final country = countryByNode[node];
      probes.add(RegionProbe(location: country ?? node, reachable: ok));
      if (ok) {
        reachable++;
      } else {
        if (country != null) blocked.add(country);
      }
    });
    if (total == 0) return const RegionReport.unavailable();
    return RegionReport(
      available: true,
      total: total,
      reachable: reachable,
      blockedCountries: blocked.toList()..sort(),
      probes: probes,
    );
  }
}
