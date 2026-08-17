import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/verdict_visuals.dart';

/// The categories that mean the connection itself is broken. Everything else is
/// a working link, graded by how much it can carry.
const _broken = [
  VerdictCategory.notConnected,
  VerdictCategory.routerNotResponding,
  VerdictCategory.captivePortal,
  VerdictCategory.noInternetIsp,
  VerdictCategory.mobileNoData,
  VerdictCategory.dnsProblem,
  VerdictCategory.portBlocked,
  VerdictCategory.ispPathProblem,
];

void main() {
  group('VerdictVisuals.iconFor', () {
    test('gives every category its own icon', () {
      // Two categories sharing an icon would show the user the same picture for
      // "no Wi-Fi" and "DNS is broken", which are different problems with
      // different fixes.
      final icons = VerdictCategory.values.map(VerdictVisuals.iconFor).toList();
      expect(icons.toSet(), hasLength(VerdictCategory.values.length));
    });

    test('names the problem it stands for', () {
      expect(
        VerdictVisuals.iconFor(VerdictCategory.notConnected),
        Icons.signal_wifi_off,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.routerNotResponding),
        Icons.router,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.captivePortal),
        Icons.login,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.noInternetIsp),
        Icons.cloud_off,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.mobileNoData),
        Icons.signal_cellular_connected_no_internet_4_bar,
      );
      expect(VerdictVisuals.iconFor(VerdictCategory.dnsProblem), Icons.dns);
      expect(VerdictVisuals.iconFor(VerdictCategory.portBlocked), Icons.block);
      expect(
        VerdictVisuals.iconFor(VerdictCategory.ispPathProblem),
        Icons.alt_route,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.connectionGood),
        Icons.check_circle,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.connectionMostlyGood),
        Icons.thumb_up_alt_outlined,
      );
      expect(
        VerdictVisuals.iconFor(VerdictCategory.connectionDegraded),
        Icons.speed,
      );
    });
  });

  group('VerdictVisuals.colorFor', () {
    test('grades the working link from dark green to amber', () {
      expect(
        VerdictVisuals.colorFor(VerdictCategory.connectionGood),
        Colors.green.shade800,
      );
      expect(
        VerdictVisuals.colorFor(VerdictCategory.connectionMostlyGood),
        Colors.green.shade400,
      );
      expect(
        VerdictVisuals.colorFor(VerdictCategory.connectionDegraded),
        Colors.amber.shade800,
      );
    });

    test('paints every broken connection red', () {
      for (final category in _broken) {
        expect(
          VerdictVisuals.colorFor(category),
          Colors.red.shade700,
          reason: '$category',
        );
      }
    });

    test('covers every category, so a new one cannot slip through', () {
      // Both mappings switch exhaustively over the enum; this is the test that
      // fails first when a category is added without a picture for it.
      for (final category in VerdictCategory.values) {
        expect(VerdictVisuals.colorFor(category), isNotNull);
        expect(VerdictVisuals.iconFor(category), isNotNull);
      }
      // Every category is either a working link or a broken one.
      const healthy = [
        VerdictCategory.connectionGood,
        VerdictCategory.connectionMostlyGood,
        VerdictCategory.connectionDegraded,
      ];
      expect(
        {..._broken, ...healthy},
        VerdictCategory.values.toSet(),
      );
    });
  });
}
