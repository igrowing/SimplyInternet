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
      case VerdictCategory.trafficShaping:
        return Icons.speed;
      case VerdictCategory.ispPathProblem:
        return Icons.alt_route;
      case VerdictCategory.allClear:
        return Icons.check_circle;
    }
  }

  static Color colorFor(VerdictCategory category) {
    if (category == VerdictCategory.allClear) return Colors.green;
    if (category == VerdictCategory.trafficShaping) return Colors.orange;
    return Colors.red.shade700;
  }
}
