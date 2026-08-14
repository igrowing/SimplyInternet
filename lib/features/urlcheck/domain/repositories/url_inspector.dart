import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';

/// Abstraction over the individual network probes used to diagnose a single
/// URL. Implementations must never throw: every failure is turned into an
/// explicit negative/unavailable fact (see AGENTS.md).
abstract class UrlInspector {
  /// Fetch [url] with a browser-like GET, following redirects.
  Future<HttpFetchResult> fetch(Uri url);

  /// Whether [host] resolves in DNS.
  Future<bool> dnsResolves(String host);

  /// RDAP registration facts for the registrable [domain] (e.g. example.com).
  Future<DomainInfo> domainInfo(String domain);

  /// Probe the given well-known [ports] on [host].
  Future<List<UrlPortResult>> checkPorts(String host, List<int> ports);

  /// Inspect the TLS certificate served on [host]:[port] (HTTPS only).
  Future<TlsInfo> tlsInfo(String host, int port);

  /// Check reachability of [url] from vantage points in several countries.
  Future<RegionReport> checkFromRegions(Uri url);

  /// Independent second opinion from an external outage-tracking service, used
  /// to cross-check our own findings and confirm geo-blocking.
  Future<OutageReport> crossCheckOutage(Uri url);
}
