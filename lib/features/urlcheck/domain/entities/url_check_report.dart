import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Severity of a single finding in a URL check.
enum UrlSeverity { ok, info, warning, problem }

/// One plain-language finding about the checked URL.
@immutable
class UrlFinding extends Equatable {
  const UrlFinding({
    required this.severity,
    required this.detail,
    this.title,
  });

  final UrlSeverity severity;

  /// Short headline, e.g. "Access denied (403)". Optional: when the detail
  /// says it all, leaving this out saves a line rather than repeating it.
  final String? title;

  /// What it means and what the user can do, in non-technical language.
  final String detail;

  @override
  List<Object?> get props => [severity, title, detail];
}

/// The full outcome of checking one specific URL: an overall headline plus the
/// individual findings that led to it, ordered most-severe first.
@immutable
class UrlCheckReport extends Equatable {
  const UrlCheckReport({
    required this.url,
    required this.reachable,
    required this.headline,
    required this.findings,
    this.log = const [],
  });

  /// The normalised URL that was checked.
  final String url;

  /// Whether the site loaded successfully (2xx) for this device.
  final bool reachable;

  /// One-line verdict shown at the top.
  final String headline;

  final List<UrlFinding> findings;

  /// Raw technical lines for the expandable "Technical details" section.
  final List<String> log;

  /// Worst severity across all findings, driving the headline colour/icon.
  UrlSeverity get worst {
    var worst = UrlSeverity.ok;
    for (final f in findings) {
      if (f.severity.index > worst.index) worst = f.severity;
    }
    return worst;
  }

  @override
  List<Object?> get props => [url, reachable, headline, findings, log];
}
