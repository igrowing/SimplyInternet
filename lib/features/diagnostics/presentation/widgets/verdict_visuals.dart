import 'package:flutter/material.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';

/// Icon + colour presentation for each verdict category, kept out of the page
/// so the mapping is in one place.
class VerdictVisuals {
  const VerdictVisuals._();

  static IconData iconFor(VerdictCategory category) {
    switch (category) {
      case VerdictCategory.notConnected:
        return Icons.signal_wifi_off;
      case VerdictCategory.routerNotResponding:
        return Icons.router;
      case VerdictCategory.captivePortal:
        return Icons.login;
      case VerdictCategory.noInternetIsp:
        return Icons.cloud_off;
      case VerdictCategory.mobileNoData:
        return Icons.signal_cellular_connected_no_internet_4_bar;
      case VerdictCategory.dnsProblem:
        return Icons.dns;
      case VerdictCategory.portBlocked:
        return Icons.block;
      case VerdictCategory.ispPathProblem:
        return Icons.alt_route;
      case VerdictCategory.connectionGood:
        return Icons.check_circle;
      case VerdictCategory.connectionMostlyGood:
        return Icons.thumb_up_alt_outlined;
      case VerdictCategory.connectionDegraded:
        return Icons.speed;
    }
  }

  /// Dark green when everything fits, light green when nearly everything does,
  /// amber when the link works but most activities do not fit, red when the
  /// connection itself is broken.
  static Color colorFor(VerdictCategory category) {
    switch (category) {
      case VerdictCategory.connectionGood:
        return Colors.green.shade800;
      case VerdictCategory.connectionMostlyGood:
        return Colors.green.shade400;
      case VerdictCategory.connectionDegraded:
        return Colors.amber.shade800;
      case VerdictCategory.notConnected:
      case VerdictCategory.routerNotResponding:
      case VerdictCategory.captivePortal:
      case VerdictCategory.noInternetIsp:
      case VerdictCategory.mobileNoData:
      case VerdictCategory.dnsProblem:
      case VerdictCategory.portBlocked:
      case VerdictCategory.ispPathProblem:
        return Colors.red.shade700;
    }
  }
}
