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

/// Cap on the route trace. Every hop that never answers costs its own probe
/// timeout, so an unreachable destination is the slowest check in the whole
/// diagnosis; the verdict only needs to know whether the destination was ever
/// reached, and 20 s is long enough to establish that.
const Duration kTraceTimeout = Duration(seconds: 20);

/// Public host pinged to sample Internet latency, jitter and packet loss.
const String kLatencyProbeHost = '1.1.1.1';

/// Probes per latency sample set. Ten is enough for a stable jitter and loss
/// figure while the whole set still finishes inside the parallel probe phase,
/// so it costs no extra wall-clock time.
const int kLatencySamples = 10;

/// Gap between latency probes.
const Duration kLatencyInterval = Duration(milliseconds: 200);

/// The throughput probes are time-boxed rather than size-boxed: a fixed byte
/// count makes the slowest links — exactly the ones that need a verdict — wait
/// the longest or report nothing at all.
const Duration kDownloadWindow = Duration(seconds: 5);
const Duration kUploadWindow = Duration(seconds: 3);

/// Endpoints of the throughput probes (Cloudflare's public speed service).
const String kDownloadUrl = 'https://speed.cloudflare.com/__down?bytes=';
const String kUploadUrl = 'https://speed.cloudflare.com/__up';

/// Chunk posted repeatedly by the upload probe (256 kB).
const int kUploadChunkBytes = 256 * 1024;

/// Bytes requested per download request, repeated until the window closes.
///
/// The service refuses oversized requests with a 403 and a one-byte body, so
/// the size must stay inside what it serves (25 MB is accepted, 100 MB is not)
/// instead of asking for one huge object and cutting it short.
const int kDownloadChunkBytes = 25 * 1000 * 1000;

/// At most this many activities may fail before the connection is described as
/// degraded rather than "good for everything except …".
const int kMostlyGoodFailureLimit = 3;
