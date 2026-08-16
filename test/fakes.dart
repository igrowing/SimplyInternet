import 'dart:io';
import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_inspector.dart';

/// A fully scriptable [NetworkProbe] for driving the diagnosis decision tree
/// through every branch without touching the network.
class FakeNetworkProbe implements NetworkProbe {
  FakeNetworkProbe({
    this.connectivityResult = const ConnectivityStatus(
      kind: ConnectivityKind.wifi,
      airplaneMode: false,
    ),
    this.gateway = '192.168.1.1',
    this.gatewayReachable = true,
    this.rawReachable = true,
    this.captiveResult = const CaptivePortalResult.clear(),
    this.dnsOk = true,
    this.ports = const [
      PortProbeResult(port: 443, service: 'HTTPS', reachable: true),
      PortProbeResult(port: 80, service: 'HTTP', reachable: true),
      PortProbeResult(port: 53, service: 'DNS', reachable: true),
    ],
    this.speed = const SpeedResult(
      downloadMbps: 50,
      ok: true,
      uploadMbps: 20,
      bytesReceived: 6000000,
      bytesSent: 3000000,
    ),
    this.quality = const LinkQuality(
      gateway: LatencyStats(sent: 10, rttsMs: [2, 2, 3, 2, 2, 3, 2, 2, 3, 2]),
      internet: LatencyStats(
        sent: 10,
        rttsMs: [15, 16, 15, 17, 15, 16, 15, 16, 15, 16],
      ),
      loadedRttMs: 22,
    ),
    this.usage = const DataUsage.empty(),
    this.path = const IspPathResult(
      reachedDestination: true,
      lastRespondingHop: '1.1.1.1',
    ),
    this.country = 'US',
    this.sites = const [
      SiteReachability(host: 'google.com', label: 'Google', reachable: true),
    ],
    this.throwOnConnectivity = false,
  });

  ConnectivityStatus connectivityResult;
  String? gateway;
  bool gatewayReachable;
  bool rawReachable;
  CaptivePortalResult captiveResult;
  bool dnsOk;
  List<PortProbeResult> ports;
  SpeedResult speed;
  LinkQuality quality;
  DataUsage usage;
  IspPathResult path;
  String? country;
  List<SiteReachability> sites;

  /// Makes the first probe fail, so tests can exercise the error path.
  bool throwOnConnectivity;

  /// Probe names in the order they were invoked, so tests can assert that the
  /// idle latency samples are taken before the link is saturated.
  final List<String> calls = [];

  @override
  Future<ConnectivityStatus> connectivity() async {
    if (throwOnConnectivity) {
      throw const SocketException('no interface');
    }
    return connectivityResult;
  }

  @override
  Future<String?> gatewayIp() async => gateway;

  @override
  Future<bool> pingReachable(String host) async => gatewayReachable;

  @override
  Future<bool> tcpReachable(String host, int port) async => rawReachable;

  @override
  Future<CaptivePortalResult> checkCaptivePortal() async => captiveResult;

  @override
  Future<bool> dnsResolves(String host) async => dnsOk;

  @override
  Future<List<PortProbeResult>> probeCommonPorts() async => ports;

  @override
  Future<SpeedResult> measureThroughput() async {
    calls.add('throughput');
    return speed;
  }

  @override
  Future<LinkQuality> measureLinkQuality({String? gatewayIp}) async {
    calls.add('quality');
    return quality;
  }

  @override
  DataUsage dataUsage() => usage;

  @override
  Future<IspPathResult> tracePath(String host) async => path;

  @override
  Future<String?> detectCountryCode() async => country;

  @override
  Future<List<SiteReachability>> checkPopularSites(String? countryCode) async =>
      sites;
}

/// Records the device actions requested so tests can assert on them.
class FakeDeviceActions implements DeviceActions {
  final List<String> calls = [];
  String? lastUrl;

  @override
  Future<void> openWifiSettings() async => calls.add('wifi');

  @override
  Future<void> openAirplaneSettings() async => calls.add('airplane');

  @override
  Future<void> openMobileDataSettings() async => calls.add('mobile');

  @override
  Future<void> openPrivateDnsSettings() async => calls.add('dns');

  @override
  Future<void> keepScreenOn({required bool on}) async =>
      calls.add(on ? 'screenOn' : 'screenOff');

  @override
  Future<bool> openUrl(String url) async {
    calls.add('url');
    lastUrl = url;
    return true;
  }
}

/// Scriptable [UrlInspector] returning canned facts for the URL-check flow.
class FakeUrlInspector implements UrlInspector {
  FakeUrlInspector({
    HttpFetchResult? fetchResult,
    this.dns = true,
    this.domain = const DomainInfo(checked: true, exists: true),
    this.tls = const TlsInfo(checked: true, valid: true),
    this.ports = const [],
    this.regions = const RegionReport.unavailable(),
    this.outage = const OutageReport.unavailable(),
    this.throwOnRegions = false,
    this.throwOnOutage = false,
  }) : fetchResult =
           fetchResult ?? const HttpFetchResult(reached: true, statusCode: 200);

  final HttpFetchResult fetchResult;
  final bool dns;
  final DomainInfo domain;
  final TlsInfo tls;
  final List<UrlPortResult> ports;
  final RegionReport regions;
  final OutageReport outage;
  final bool throwOnRegions;
  final bool throwOnOutage;

  /// The registrable domain the use-case asked us to look up (for assertions).
  String? lastDomainQueried;

  @override
  Future<HttpFetchResult> fetch(Uri url) async => fetchResult;

  @override
  Future<bool> dnsResolves(String host) async => dns;

  @override
  Future<DomainInfo> domainInfo(String d) async {
    lastDomainQueried = d;
    return domain;
  }

  @override
  Future<List<UrlPortResult>> checkPorts(String host, List<int> p) async =>
      ports;

  @override
  Future<TlsInfo> tlsInfo(String host, int port) async => tls;

  @override
  Future<RegionReport> checkFromRegions(Uri url) async {
    if (throwOnRegions) {
      throw StateError('region service blew up');
    }
    return regions;
  }

  @override
  Future<OutageReport> crossCheckOutage(Uri url) async {
    if (throwOnOutage) {
      throw StateError('outage service blew up');
    }
    return outage;
  }
}
