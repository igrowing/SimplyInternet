import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/popular_sites.dart';

void main() {
  group('PopularSites.targetsFor', () {
    test('includes the country top sites plus the continent baseline', () {
      final targets = PopularSites.targetsFor('IL');
      final hosts = targets.map((s) => s.host).toList();
      expect(hosts, contains('ynet.co.il'));
      // Baseline sites from every continent are always present.
      expect(hosts, contains('bbc.com'));
      expect(hosts, contains('baidu.com'));
    });

    test('deduplicates hosts while preserving order', () {
      final targets = PopularSites.targetsFor('US');
      final hosts = targets.map((s) => s.host).toList();
      expect(hosts.length, hosts.toSet().length);
    });

    test('falls back to continent baseline for unknown country', () {
      final targets = PopularSites.targetsFor('ZZ');
      expect(targets, isNotEmpty);
    });

    test('works with a null country', () {
      final targets = PopularSites.targetsFor(null);
      expect(targets, isNotEmpty);
    });

    test('maps known countries to their continent', () {
      expect(PopularSites.continentOf('BR'), Continent.southAmerica);
      expect(PopularSites.continentOf('JP'), Continent.asia);
      expect(PopularSites.continentOf('zz'), isNull);
    });
  });
}
