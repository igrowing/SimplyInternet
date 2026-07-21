/// Centralized TCP/UDP port definitions for SimplyNet.
///
/// Every list and port→service map used across the app is defined here so the
/// port data lives in a single, reviewable place. Callers reference these
/// constants instead of hard-coding port literals; moving the values here does
/// not change any behavior.
library;

abstract final class NetworkPorts {
  // ── General port scanning ────────────────────────────────────────────────
  /// Well-known ports dictionary: port number → service name.
  /// Used by the generic TCP/UDP port scanner (NetworkTools.portScan) and as
  /// the default port set when "well-known ports" is selected in the UI.
  /// Use `.keys.toList()` wherever a `List<int>` of port numbers is needed.
  static const Map<int, String> wellKnownPortNames = <int, String>{
    21:    'ftp',
    22:    'ssh',
    23:    'telnet',
    25:    'smtp',
    53:    'dns',
    80:    'http',
    81:    'http-alt',
    82:    'http-alt',
    83:    'http-alt',
    84:    'http-alt',
    85:    'http-alt',
    110:   'pop3',
    143:   'imap',
    161:   'snmp',
    443:   'https',
    445:   'smb',
    465:   'smtps',
    587:   'submission',
    631:   'ipp',
    993:   'imaps',
    995:   'pop3s',
    1080:  'socks',
    1194:  'openvpn',
    1433:  'mssql',
    1521:  'oracle',
    1723:  'pptp',
    1883:  'mqtt',
    1935:  'rtmp',
    2049:  'nfs',
    3306:  'mysql',
    3389:  'rdp',
    4040:  'kasa',
    5353:  'mdns',
    5432:  'postgresql',
    5540:  'matter',
    5554:  'rtsp',
    5900:  'vnc',
    6379:  'redis',
    6668:  'meross',
    8080:  'http-alt',
    8081:  'http-alt2',
    8123:  'home-assistant',
    8443:  'https-alt',
    8554:  'rtsp-alt',
    8883:  'mqtt-tls',
    8888:  'zigbee2mqtt',
    9000:  'openhab',
    9001:  'openhab-alt',
    9200:  'elasticsearch',
    9443:  'openhab-tls',
    9999:  'kasa-legacy',
    10554: 'rtsp-alt2',
    20202: 'matter-comm',
    27017: 'mongodb',
    34567: 'dvr-http',
    34599: 'dvr-alt',
    37777: 'dahua',
    37778: 'dahua-alt',
    49153: 'wemo',
    55443: 'xiaomi-miio',
  };

  // ── IoT device discovery (IotScanner) ────────────────────────────────────
  /// IoT TCP port definitions: port number → protocol label.
  static const Map<int, String> iotPortNames = <int, String>{
    80:   'HTTP',
    443:  'HTTPS',
    1883: 'MQTT',
    8883: 'MQTT-TLS',
    8080: 'HTTP-alt',
    8081: 'HTTP-alt2',
    8123: 'Home Assistant',
    8443: 'HTTPS-alt',
    1080: 'SOCKS/proxy',
    5353: 'mDNS',          // UDP — handled separately
    5540: 'Matter',
    8888: 'Zigbee2MQTT',
    9000: 'openHAB',
    9443: 'openHAB-TLS',
    49153: 'WeMo',
    55443: 'Xiaomi MiIO',
    6668:  'Meross',
    4040:  'TP-Link Kasa',
    9999:  'TP-Link Kasa legacy',
    20202: 'Matter commissioning',
  };

  // ── IP camera detection (IpCameraDetector) ───────────────────────────────
  /// Ports that are unambiguously camera protocols — any open port = camera.
  static const List<int> cameraSpecificPorts = [
    554,   // RTSP (standard)
    5554,  // RTSP (alt)
    8554,  // RTSP (alt)
    10554, // RTSP (alt)
    37777, // Dahua / Reolink proprietary
    37778, // Dahua / Reolink proprietary
    1935,  // RTMP streaming
    34567, // XMEye / Generic DVR
    34599, // XMEye / Generic DVR
  ];

  /// Ports that host web interfaces on many device types.
  /// Require extra evidence (manufacturer name or HTTP banner).
  static const List<int> cameraGenericPorts = [80, 443, 8080, 8443, 8000, 9000, 9001, 81, 82, 83, 84, 85];

  /// All ports to probe per host during a camera scan.
  static const List<int> cameraAllPorts = [...cameraSpecificPorts, ...cameraGenericPorts];

  // ── Host liveness probing (NetworkScanner) ───────────────────────────────
  /// Probed when ICMP/ARP discovery is inconclusive. Covers web, SSH, SMB,
  /// Matter, MQTT, TP-Link, and IoT HTTP services.
  static const List<int> livenessProbePorts = [80, 443, 22, 445, 8080, 5540, 8123, 1883, 8883, 8081, 9999, 4040];

  // ── Individual protocol ports ────────────────────────────────────────────
  /// Multicast DNS (UDP). Skipped during TCP-only IoT port scans.
  static const int mdnsPort = 5353;

  /// WS-Discovery multicast probe port (UDP) used for ONVIF camera discovery.
  static const int wsDiscoveryPort = 3702;

  /// Default MQTT broker port (used by the MQTT client screen).
  static const int defaultMqttPort = 1883;
}
