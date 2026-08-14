import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';

/// Continents used to pick globally-representative reachability targets.
enum Continent { northAmerica, southAmerica, europe, africa, asia, oceania }

/// A popular website used as a reachability probe.
class PopularSite {
  const PopularSite({required this.host, required this.label});

  final String host;
  final String label;

  SiteReachability get pending =>
      SiteReachability(host: host, label: label, reachable: false);
}

/// Internal database of popular sites keyed by ISO-3166 alpha-2 country code
/// and, as a global baseline, by [Continent]. Used to verify that real
/// user-facing destinations resolve and connect, not just the DNS anycast IPs.
///
/// The lists are intentionally small (top ~2 per country) to keep the check
/// fast; a broad country list is impractical to maintain exhaustively, so the
/// continent baseline guarantees meaningful coverage for any location.
class PopularSites {
  const PopularSites._();

  /// Two of the most-visited sites per country (best-effort, non-exhaustive).
  static const Map<String, List<PopularSite>> byCountry = {
    'US': [
      PopularSite(host: 'google.com', label: 'Google'),
      PopularSite(host: 'amazon.com', label: 'Amazon'),
    ],
    'GB': [
      PopularSite(host: 'google.co.uk', label: 'Google UK'),
      PopularSite(host: 'bbc.co.uk', label: 'BBC'),
    ],
    'DE': [
      PopularSite(host: 'google.de', label: 'Google DE'),
      PopularSite(host: 'ebay.de', label: 'eBay DE'),
    ],
    'FR': [
      PopularSite(host: 'google.fr', label: 'Google FR'),
      PopularSite(host: 'leboncoin.fr', label: 'Leboncoin'),
    ],
    'IT': [
      PopularSite(host: 'google.it', label: 'Google IT'),
      PopularSite(host: 'repubblica.it', label: 'la Repubblica'),
    ],
    'ES': [
      PopularSite(host: 'google.es', label: 'Google ES'),
      PopularSite(host: 'marca.com', label: 'Marca'),
    ],
    'RU': [
      PopularSite(host: 'yandex.ru', label: 'Yandex'),
      PopularSite(host: 'vk.com', label: 'VK'),
    ],
    'IN': [
      PopularSite(host: 'google.co.in', label: 'Google IN'),
      PopularSite(host: 'flipkart.com', label: 'Flipkart'),
    ],
    'CN': [
      PopularSite(host: 'baidu.com', label: 'Baidu'),
      PopularSite(host: 'qq.com', label: 'QQ'),
    ],
    'JP': [
      PopularSite(host: 'google.co.jp', label: 'Google JP'),
      PopularSite(host: 'yahoo.co.jp', label: 'Yahoo! JP'),
    ],
    'BR': [
      PopularSite(host: 'google.com.br', label: 'Google BR'),
      PopularSite(host: 'globo.com', label: 'Globo'),
    ],
    'IL': [
      PopularSite(host: 'google.co.il', label: 'Google IL'),
      PopularSite(host: 'ynet.co.il', label: 'Ynet'),
    ],
    'AU': [
      PopularSite(host: 'google.com.au', label: 'Google AU'),
      PopularSite(host: 'news.com.au', label: 'news.com.au'),
    ],
    'CA': [
      PopularSite(host: 'google.ca', label: 'Google CA'),
      PopularSite(host: 'cbc.ca', label: 'CBC'),
    ],
    'ZA': [
      PopularSite(host: 'google.co.za', label: 'Google ZA'),
      PopularSite(host: 'news24.com', label: 'News24'),
    ],
  };

  /// Two representative popular sites per continent — the global baseline.
  static const Map<Continent, List<PopularSite>> byContinent = {
    Continent.northAmerica: [
      PopularSite(host: 'google.com', label: 'Google'),
      PopularSite(host: 'wikipedia.org', label: 'Wikipedia'),
    ],
    Continent.southAmerica: [
      PopularSite(host: 'globo.com', label: 'Globo (BR)'),
      PopularSite(host: 'mercadolibre.com', label: 'MercadoLibre'),
    ],
    Continent.europe: [
      PopularSite(host: 'bbc.com', label: 'BBC'),
      PopularSite(host: 'spiegel.de', label: 'Der Spiegel'),
    ],
    Continent.africa: [
      PopularSite(host: 'news24.com', label: 'News24 (ZA)'),
      PopularSite(host: 'jumia.com', label: 'Jumia'),
    ],
    Continent.asia: [
      PopularSite(host: 'baidu.com', label: 'Baidu (CN)'),
      PopularSite(host: 'rakuten.co.jp', label: 'Rakuten (JP)'),
    ],
    Continent.oceania: [
      PopularSite(host: 'news.com.au', label: 'news.com.au'),
      PopularSite(host: 'stuff.co.nz', label: 'Stuff (NZ)'),
    ],
  };

  /// Map an ISO country code to its continent (partial — unknown countries
  /// simply fall back to the continent baseline in [targetsFor]).
  static const Map<String, Continent> _countryContinent = {
    'US': Continent.northAmerica,
    'CA': Continent.northAmerica,
    'MX': Continent.northAmerica,
    'BR': Continent.southAmerica,
    'AR': Continent.southAmerica,
    'CL': Continent.southAmerica,
    'GB': Continent.europe,
    'DE': Continent.europe,
    'FR': Continent.europe,
    'IT': Continent.europe,
    'ES': Continent.europe,
    'RU': Continent.europe,
    'IL': Continent.asia,
    'IN': Continent.asia,
    'CN': Continent.asia,
    'JP': Continent.asia,
    'ZA': Continent.africa,
    'NG': Continent.africa,
    'EG': Continent.africa,
    'AU': Continent.oceania,
    'NZ': Continent.oceania,
  };

  /// The continent a country belongs to, or null when unknown.
  static Continent? continentOf(String countryCode) =>
      _countryContinent[countryCode.toUpperCase()];

  /// Build the reachability target list for a location: the country's top
  /// sites (when known) plus two sites from every continent as a baseline.
  /// Duplicate hosts are removed while preserving order. When [countryCode]
  /// is null only the continent baseline is used.
  static List<PopularSite> targetsFor(String? countryCode) {
    final seen = <String>{};
    final out = <PopularSite>[];

    void add(PopularSite s) {
      if (seen.add(s.host)) out.add(s);
    }

    if (countryCode != null) {
      final country = byCountry[countryCode.toUpperCase()];
      if (country != null) country.forEach(add);
    }
    for (final sites in byContinent.values) {
      sites.forEach(add);
    }
    return out;
  }
}
