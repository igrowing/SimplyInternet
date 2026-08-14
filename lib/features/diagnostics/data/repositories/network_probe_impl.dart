import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/platform_actions_datasource.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/vendor/network_tools.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/popular_sites.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';

/// Concrete [NetworkProbe] built on `connectivity_plus`, `network_info_plus`,
/// `dart:io` sockets, `http`, and the vendored SimplyNet [NetworkTools]
/// (traceroute). Every failure is turned into an explicit negative result
/// (unreachable / false) rather than a silent default (see AGENTS.md).
class NetworkProbeImpl implements NetworkProbe {
  NetworkProbeImpl({
    Connectivity? connectivity,
    NetworkInfo? networkInfo,
    PlatformActionsDatasource platform = const PlatformActionsDatasource(),
    http.Client Function()? clientFactory,
  }) : _connectivity = connectivity ?? Connectivity(),
       _networkInfo = networkInfo ?? NetworkInfo(),
       _platform = platform,
       _clientFactory = clientFactory ?? http.Client.new;

  final Connectivity _connectivity;
  final NetworkInfo _networkInfo;
  final PlatformActionsDatasource _platform;
  final http.Client Function() _clientFactory;

  @override
  Future<ConnectivityStatus> connectivity() async {
    final results = await _connectivity.checkConnectivity();
    final airplane = await _platform.isAirplaneModeOn();
    return ConnectivityStatus(
      kind: _mapConnectivity(results),
      airplaneMode: airplane,
    );
  }

  static ConnectivityKind _mapConnectivity(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityKind.wifi;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityKind.ethernet;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityKind.mobile;
    }
    if (results.contains(ConnectivityResult.vpn)) {
      return ConnectivityKind.vpn;
    }
    final onlyNone = results.every((r) => r == ConnectivityResult.none);
    return onlyNone ? ConnectivityKind.none : ConnectivityKind.other;
  }

  @override
  Future<String?> gatewayIp() async {
    try {
      final gw = await _networkInfo.getWifiGatewayIP();
      if (gw != null && gw.isNotEmpty) return gw;
    } on Exception {
      // Fall through to null — gateway is simply unknown.
    }
    return null;
  }

  @override
  Future<bool> pingReachable(String host) async {
    try {
      final result = await Process.run('ping', [
        '-c',
        '1',
        '-W',
        '2',
        host,
      ]).timeout(const Duration(seconds: 4));
      if (result.exitCode == 0) return true;
    } on Exception {
      // ping binary unavailable or timed out — fall back to TCP below.
    }
    // Fallback: many gateways answer a TCP SYN on 80/443 even without ICMP.
    return await tcpReachable(host, 80) || await tcpReachable(host, 443);
  }

  @override
  Future<bool> tcpReachable(String host, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 3),
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
  Future<CaptivePortalResult> checkCaptivePortal() async {
    var sawPortal = false;
    String? portalUrl;
    for (final endpoint in kCheck204Endpoints) {
      final outcome = await _probe204(endpoint.url);
      switch (outcome.kind) {
        case _Http204Kind.clear:
          return const CaptivePortalResult.clear();
        case _Http204Kind.portal:
          sawPortal = true;
          portalUrl ??= outcome.portalUrl ?? endpoint.url;
        case _Http204Kind.unreachable:
          break;
      }
    }
    if (sawPortal) {
      return CaptivePortalResult.portal(
        portalUrl ?? kCheck204Endpoints.first.url,
      );
    }
    return const CaptivePortalResult.noInternet();
  }

  Future<_Http204Outcome> _probe204(String url) async {
    final client = _clientFactory();
    try {
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false
        ..headers['User-Agent'] = 'SimplyInternet/1.0';
      final streamed = await client
          .send(request)
          .timeout(const Duration(seconds: 6));
      final response = await http.Response.fromStream(streamed);
      final code = response.statusCode;
      if (code == 204 && response.bodyBytes.isEmpty) {
        return const _Http204Outcome(_Http204Kind.clear);
      }
      if (code >= 300 && code < 400) {
        return _Http204Outcome(
          _Http204Kind.portal,
          portalUrl: response.headers['location'],
        );
      }
      // Any other answer (200 with a login page, 511, etc.) is a portal.
      return _Http204Outcome(_Http204Kind.portal, portalUrl: url);
    } on TimeoutException {
      return const _Http204Outcome(_Http204Kind.unreachable);
    } on http.ClientException {
      return const _Http204Outcome(_Http204Kind.unreachable);
    } on SocketException {
      return const _Http204Outcome(_Http204Kind.unreachable);
    } finally {
      client.close();
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
  Future<List<PortProbeResult>> probeCommonPorts() async {
    final out = <PortProbeResult>[];
    for (final t in kPortProbeTargets) {
      final ok = await tcpReachable(t.host, t.port);
      out.add(PortProbeResult(port: t.port, service: t.service, reachable: ok));
    }
    return out;
  }

  @override
  Future<SpeedResult> measureSpeed() async {
    const bytes = 8 * 1000 * 1000; // ~8 MB sample
    final uri = Uri.parse('https://speed.cloudflare.com/__down?bytes=$bytes');
    final client = _clientFactory();
    try {
      final request = http.Request('GET', uri)
        ..headers['User-Agent'] = 'SimplyInternet/1.0';
      final sw = Stopwatch()..start();
      final streamed = await client
          .send(request)
          .timeout(const Duration(seconds: 8));
      var received = 0;
      await for (final chunk in streamed.stream.timeout(
        const Duration(seconds: 8),
      )) {
        received += chunk.length;
      }
      sw.stop();
      final seconds = sw.elapsedMilliseconds / 1000.0;
      if (received <= 0 || seconds <= 0) return const SpeedResult.unavailable();
      final mbps = (received * 8) / seconds / 1000000.0;
      return SpeedResult(downloadMbps: mbps, ok: true);
    } on TimeoutException {
      return const SpeedResult.unavailable();
    } on http.ClientException {
      return const SpeedResult.unavailable();
    } on SocketException {
      return const SpeedResult.unavailable();
    } finally {
      client.close();
    }
  }

  @override
  Future<IspPathResult> tracePath(String host) async {
    try {
      var reached = false;
      String? lastHop;
      int? firstDead;
      await for (final hop in NetworkTools.tracerouteHops(
        host,
        maxHops: 20,
      ).timeout(const Duration(seconds: 60))) {
        if (hop.ip != null) {
          lastHop = hop.hostname != null
              ? '${hop.hostname} (${hop.ip})'
              : hop.ip;
        } else {
          firstDead ??= hop.hop;
        }
        if (hop.reached) {
          reached = true;
          break;
        }
      }
      return IspPathResult(
        reachedDestination: reached,
        lastRespondingHop: lastHop,
        firstDeadHop: firstDead,
      );
    } on TracerouteException {
      return const IspPathResult(reachedDestination: false);
    } on TimeoutException {
      return const IspPathResult(reachedDestination: false);
    }
  }

  @override
  Future<String?> detectCountryCode() async {
    final client = _clientFactory();
    try {
      final resp = await client
          .get(Uri.parse('https://www.cloudflare.com/cdn-cgi/trace'))
          .timeout(const Duration(seconds: 6));
      if (resp.statusCode != 200) return null;
      for (final line in resp.body.split('\n')) {
        if (line.startsWith('loc=')) {
          final code = line.substring(4).trim().toUpperCase();
          return code.isEmpty ? null : code;
        }
      }
      return null;
    } on TimeoutException {
      return null;
    } on http.ClientException {
      return null;
    } on SocketException {
      return null;
    } finally {
      client.close();
    }
  }

  @override
  Future<List<SiteReachability>> checkPopularSites(String? countryCode) async {
    final targets = PopularSites.targetsFor(countryCode);
    final futures = targets.map((site) async {
      final ok = await tcpReachable(site.host, 443);
      return SiteReachability(
        host: site.host,
        label: site.label,
        reachable: ok,
      );
    });
    return Future.wait(futures);
  }
}

enum _Http204Kind { clear, portal, unreachable }

class _Http204Outcome {
  const _Http204Outcome(this.kind, {this.portalUrl});

  final _Http204Kind kind;
  final String? portalUrl;
}
