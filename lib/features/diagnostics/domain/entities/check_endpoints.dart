/// A connectivity-check endpoint expected to return HTTP 204 (No Content).
///
/// A clean 204 with an empty body proves unintercepted Internet access.
/// Anything else (a redirect, a login page, a non-empty body) is the classic
/// signature of a captive portal.
class Check204Endpoint {
  const Check204Endpoint({required this.name, required this.url});

  final String name;
  final String url;
}

/// The canonical HTTP-204 captive-portal probes.
///
/// * Android uses `connectivitycheck.gstatic.com/generate_204`.
/// * Cloudflare provides `cp.cloudflare.com/generate_204`.
const List<Check204Endpoint> kCheck204Endpoints = [
  Check204Endpoint(
    name: 'Android',
    url: 'http://connectivitycheck.gstatic.com/generate_204',
  ),
  Check204Endpoint(
    name: 'Cloudflare',
    url: 'http://cp.cloudflare.com/generate_204',
  ),
];

/// Public IP literals used to test raw (DNS-independent) reachability.
///
/// If a TCP handshake to any of these succeeds we have a working path to the
/// Internet even when DNS is broken; the port pairs are chosen so a firewall
/// blocking one protocol does not hide the others.
const List<({String ip, int port})> kRawReachabilityTargets = [
  (ip: '1.1.1.1', port: 443), // Cloudflare DNS over HTTPS
  (ip: '8.8.8.8', port: 53), // Google DNS
  (ip: '9.9.9.9', port: 443), // Quad9
];

/// A public host that reliably resolves, used to test DNS name resolution.
const String kDnsProbeHost = 'cloudflare.com';

/// Public hosts + ports probed to detect a blocked outbound port. Each entry
/// is a service that is essentially always reachable on the given port unless
/// a firewall blocks that specific port.
const List<({String host, int port, String service})> kPortProbeTargets = [
  (host: '1.1.1.1', port: 443, service: 'HTTPS'),
  (host: 'example.com', port: 80, service: 'HTTP'),
  (host: '1.1.1.1', port: 53, service: 'DNS'),
];

/// Destination used for the ISP path (traceroute) check.
const String kPathProbeHost = '1.1.1.1';

/// Below this download rate (Mbps) the connection is flagged as *possibly*
/// throttled/shaped. Deliberately conservative — shaping is reported as a
/// possibility, never a certainty.
const double kThrottleSuspicionMbps = 1.5;
