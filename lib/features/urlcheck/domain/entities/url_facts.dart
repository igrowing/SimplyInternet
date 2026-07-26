import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Raw result of fetching the URL over HTTP(S), following redirects.
@immutable
class HttpFetchResult extends Equatable {
  const HttpFetchResult({
    required this.reached,
    this.statusCode,
    this.finalUrl,
    this.elapsedMs,
    this.error,
  });

  /// A dead result used when the request could not even leave the device.
  const HttpFetchResult.failed(String reason)
    : reached = false,
      statusCode = null,
      finalUrl = null,
      elapsedMs = null,
      error = reason;

  /// Whether any HTTP response at all was received.
  final bool reached;

  /// The final status code after redirects, when [reached] is true.
  final int? statusCode;

  /// The URL the request finally landed on (after any redirects).
  final String? finalUrl;

  /// Round-trip time of the request in milliseconds, when known.
  final int? elapsedMs;

  /// Transport-level error text when the request never got a response.
  final String? error;

  bool get isSuccess =>
      reached && statusCode != null && statusCode! >= 200 && statusCode! < 300;

  @override
  List<Object?> get props => [reached, statusCode, finalUrl, elapsedMs, error];
}

/// Domain registration facts, sourced from RDAP.
@immutable
class DomainInfo extends Equatable {
  const DomainInfo({
    required this.checked,
    this.exists = false,
    this.expired = false,
    this.expiry,
    this.error,
  });

  const DomainInfo.unavailable()
    : checked = false,
      exists = false,
      expired = false,
      expiry = null,
      error = null;

  /// Whether the RDAP lookup completed (regardless of the answer).
  final bool checked;

  /// Whether the registry knows this domain.
  final bool exists;

  /// Whether the registration has passed its expiry date.
  final bool expired;

  /// The registration expiry date, when the registry reports one.
  final DateTime? expiry;

  final String? error;

  @override
  List<Object?> get props => [checked, exists, expired, expiry, error];
}

/// TLS certificate facts for an HTTPS endpoint.
@immutable
class TlsInfo extends Equatable {
  const TlsInfo({
    required this.checked,
    this.valid = false,
    this.expiry,
    this.issue,
  });

  const TlsInfo.unavailable()
    : checked = false,
      valid = false,
      expiry = null,
      issue = null;

  /// Whether a TLS check was attempted (false for plain-HTTP URLs).
  final bool checked;

  /// Whether the certificate validated and the handshake succeeded.
  final bool valid;

  /// Certificate expiry date, when it could be read.
  final DateTime? expiry;

  /// A short description of the problem when [valid] is false.
  final String? issue;

  @override
  List<Object?> get props => [checked, valid, expiry, issue];
}

/// Reachability of an individual well-known port.
@immutable
class UrlPortResult extends Equatable {
  const UrlPortResult({
    required this.port,
    required this.service,
    required this.open,
  });

  final int port;
  final String service;
  final bool open;

  @override
  List<Object?> get props => [port, service, open];
}

/// Multi-country reachability, used to tell "down for everyone" apart from
/// regional/geo-blocking, without needing a VPN on the device.
@immutable
class RegionReport extends Equatable {
  const RegionReport({
    required this.available,
    this.total = 0,
    this.reachable = 0,
    this.blockedCountries = const [],
  });

  const RegionReport.unavailable()
    : available = false,
      total = 0,
      reachable = 0,
      blockedCountries = const [];

  /// Whether the external multi-node check produced any usable data.
  final bool available;

  /// Number of vantage-point nodes that answered.
  final int total;

  /// How many of those nodes could reach the URL.
  final int reachable;

  /// Country codes of nodes that could NOT reach the URL.
  final List<String> blockedCountries;

  bool get reachableFromSome => reachable > 0;
  bool get reachableFromAll => available && total > 0 && reachable == total;
  bool get downEverywhere => available && total > 0 && reachable == 0;

  @override
  List<Object?> get props => [available, total, reachable, blockedCountries];
}
