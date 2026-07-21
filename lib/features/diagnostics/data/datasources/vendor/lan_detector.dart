import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// LAN detection — produces a real CIDR string (e.g. "192.168.1.0/24")
/// using the actual subnet mask reported by the OS via network_info_plus,
/// with a multi-stage fallback chain for non-WiFi / edge-case environments.
///
/// Detection stages (tried in order):
///   1. network_info_plus → getWifiIP() + getWifiSubmask()
///      → real IP + real mask, most accurate on WiFi (Android / iOS / desktop)
///   2. network_info_plus → getWifiGatewayIP() / getWifiIP() without mask
///      → fallback when mask unavailable (Android 15+ bug)
///   3. dart:io NetworkInterface enumeration
///      → works on non-WiFi (Ethernet, USB tethering, VPN)
///   4. Heuristic /24 from device IP — last resort

Future<String?> detectLanCidr() async {
  if (kIsWeb) {
    debugPrint('LAN detection skipped: unavailable on web');
    return null;
  }

  // ── Stage 1: network_info_plus (WiFi with real subnet mask) ───────────────
  try {
    final info    = NetworkInfo();
    final ip      = await info.getWifiIP();
    final submask = await info.getWifiSubmask();

    if (ip != null && ip.isNotEmpty && submask != null && submask.isNotEmpty) {
      final prefix  = subnetMaskToPrefix(submask);
      final network = networkAddress(ip, prefix);
      debugPrint('LAN detect [stage 1 — WiFi+mask]: $ip / $submask → $network/$prefix');
      return '$network/$prefix';
    }

    // ── Stage 2: gateway / device IP without real mask ────────────────────
    String? gatewayIp;
    try { gatewayIp = await info.getWifiGatewayIP(); } catch (_) {}
    final sourceIp = ip ?? gatewayIp;

    if (sourceIp != null && sourceIp.isNotEmpty) {
      final prefix  = inferPrefixFromAddress(sourceIp);
      final network = networkAddress(sourceIp, prefix);
      debugPrint('LAN detect [stage 2 — gateway/ip]: $sourceIp → $network/$prefix');
      return '$network/$prefix';
    }
  } catch (e) {
    debugPrint('LAN detect stages 1-2 failed: $e');
  }

  // ── Stage 3: dart:io NetworkInterface (Ethernet / USB tethering / VPN) ───
  try {
    final ifaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    for (final iface in ifaces) {
      for (final addr in iface.addresses) {
        if (!addr.isLoopback && addr.address.isNotEmpty) {
          final prefix  = inferPrefixFromAddress(addr.address);
          final network = networkAddress(addr.address, prefix);
          debugPrint('LAN detect [stage 3 — NetworkInterface "${iface.name}"]: '
              '${addr.address} → $network/$prefix');
          return '$network/$prefix';
        }
      }
    }
  } catch (e) {
    debugPrint('LAN detect stage 3 failed: $e');
  }

  debugPrint('LAN detect: all stages failed');
  return null;
}

/// Convert a dotted-decimal subnet mask to a CIDR prefix length.
///
/// Counts contiguous leading 1-bits across all four octets.
/// Returns 24 (safe default) for any invalid or non-contiguous mask.
///
/// Examples:
///   "255.255.255.0"   → 24
///   "255.255.0.0"     → 16
///   "255.255.255.128" → 25
///   "255.0.255.0"     → 24  (non-contiguous — rejected)
///   ""                → 24  (invalid — rejected)
@visibleForTesting
int subnetMaskToPrefix(String mask) {
  try {
    final octets = mask.split('.').map(int.parse).toList();
    if (octets.length != 4) return 24;
    int bits = 0;
    bool seenZero = false; // true once we encounter the first 0-bit
    for (final octet in octets) {
      if (octet < 0 || octet > 255) return 24;
      if (seenZero) {
        // After the first 0-bit, every remaining octet must be all-zeros
        if (octet != 0) return 24;
      } else {
        int octetBits = octet;
        while (octetBits & 0x80 != 0) {
          bits++;
          octetBits = (octetBits << 1) & 0xFF;
        }
        if (octetBits != 0) {
          // A 1-bit after a 0-bit within the same octet → non-contiguous
          return 24;
        }
        if (octet != 0xFF) seenZero = true; // this octet contained a 0-bit
      }
    }
    return bits;
  } catch (_) {
    return 24;
  }
}

/// Infer prefix from IP address class when no mask is available.
///
/// All RFC-1918 ranges → /24 (most common SOHO deployment).
@visibleForTesting
int inferPrefixFromAddress(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return 24;
  try {
    final first = int.parse(parts[0]);
    if (first == 10)  return 24;
    if (first == 172) return 24;
    if (first == 192) return 24;
  } catch (_) {}
  return 24;
}

/// Return the network address (host bits zeroed) for [ip] with [prefix] bits.
///
/// Example: networkAddress('192.168.1.100', 24) → '192.168.1.0'
/// Returns [ip] unchanged on invalid input.
@visibleForTesting
String networkAddress(String ip, int prefix) {
  try {
    final octets = ip.split('.').map(int.parse).toList();
    if (octets.length != 4) return ip;
    if (prefix < 0 || prefix > 32) return ip;

    final ipInt = (octets[0] << 24) | (octets[1] << 16) |
                  (octets[2] << 8)  |  octets[3];
    final mask  = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net   = ipInt & mask;

    return '${(net >> 24) & 0xFF}.'
        '${(net >> 16) & 0xFF}.'
        '${(net >> 8)  & 0xFF}.'
        '${net         & 0xFF}';
  } catch (e) {
    debugPrint('networkAddress($ip, $prefix): $e');
    return ip;
  }
}
