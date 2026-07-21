import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;

/// One server from Ookla's speedtest.net fleet.
class OoklaServer {
  final String host; // "name.example.com:8080" (may include a port)
  final String sponsor; // operator name
  final String name; // city
  final String country;

  const OoklaServer({
    required this.host,
    this.sponsor = '',
    this.name = '',
    this.country = '',
  });

  String get label {
    final place = [name, country].where((s) => s.isNotEmpty).join(', ');
    if (sponsor.isEmpty) return place.isEmpty ? host : place;
    return place.isEmpty ? sponsor : '$sponsor — $place';
  }

  Uri downloadUri(int bytes) =>
      Uri.parse('https://$host/download?nocache=${_nonce()}&size=$bytes');
  Uri uploadUri() => Uri.parse('https://$host/upload?nocache=${_nonce()}');

  static String _nonce() => Random().nextInt(0x7fffffff).toString();
}

/// Measures connection speed against Ookla's third-party speedtest.net servers
/// over HTTPS. Used only after the user has accepted the Ookla consent.
class OoklaSpeedTest {
  static const serversUrl =
      'https://www.speedtest.net/api/js/servers?engine=js&limit=10';

  /// speedtest.net's API returns 403 to the default Dart user-agent, so all
  /// requests pose as a regular browser.
  static const Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, '
        'like Gecko) Chrome/124.0 Mobile Safari/537.36',
  };

  /// Parse the speedtest.net server-list JSON into [OoklaServer]s. Pure so it
  /// can be unit-tested without network access. Tolerates malformed entries.
  static List<OoklaServer> parseServers(String body) {
    dynamic data;
    try {
      data = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    if (data is! List) return const [];
    final out = <OoklaServer>[];
    for (final e in data) {
      if (e is! Map) continue;
      final host = (e['host'] as String?)?.trim();
      if (host == null || host.isEmpty) continue;
      out.add(
        OoklaServer(
          host: host,
          sponsor: (e['sponsor'] as String?)?.trim() ?? '',
          name: (e['name'] as String?)?.trim() ?? '',
          country: (e['country'] as String?)?.trim() ?? '',
        ),
      );
    }
    return out;
  }

  /// Fetch the nearest candidate servers from speedtest.net.
  static Future<List<OoklaServer>> fetchServers() async {
    final resp = await http
        .get(Uri.parse(serversUrl), headers: headers)
        .timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) {
      throw Exception('Ookla server list returned HTTP ${resp.statusCode}');
    }
    return parseServers(resp.body);
  }

  /// Probe [servers] in order and return the first that answers, with its
  /// round-trip latency in milliseconds. Throws when none are reachable.
  static Future<({OoklaServer server, double pingMs})> bestServer(
    List<OoklaServer> servers,
  ) async {
    if (servers.isEmpty) throw Exception('No Ookla servers available');

    // Stores successful pings
    final results = <({OoklaServer server, double pingMs})>[];
    
    // Shared state across all workers
    int currentIndex = 0;
    bool foundFastEnough = false;
    
    // The Completer allows us to return instantly when our condition is met
    final completer = Completer<({OoklaServer server, double pingMs})>();

    // Define the worker logic
    Future<void> worker() async {
      // Worker stops automatically if another worker finds a fast server
      while (!foundFastEnough) {
        final int index = currentIndex++;
        if (index >= servers.length) break;

        final s = servers[index];
        try {
          final sw = Stopwatch()..start();
          final r = await http
              .get(s.downloadUri(1), headers: headers)
              .timeout(const Duration(seconds: 4));
          sw.stop();
          
          if (r.statusCode == 200) {
            final ping = sw.elapsedMilliseconds.toDouble();
            final result = (server: s, pingMs: ping);
            results.add(result);
            // EARLY EXIT: If we find a server under 7ms, trigger the return immediately!
            if (ping < 7.0 && !foundFastEnough) {
              foundFastEnough = true; // Signals other threads to stop
              if (!completer.isCompleted) {
                completer.complete(result);
              }
              break;
            }
          }
        } catch (_) {
          // If a server times out or fails, quietly move to the next one
        }
      }
    }

    // Spawn up to 16 concurrent workers
    final int threadCount = servers.length < 16 ? servers.length : 16;
    final workers = List.generate(threadCount, (_) => worker());
    
    // When all workers finish naturally (if no server was < 7ms)
    Future.wait(workers).then((_) {
      if (!completer.isCompleted) {
        if (results.isEmpty) {
          completer.completeError(Exception('No reachable Ookla server'));
        } else {
          // Compare all successful pings and return the absolute lowest
          completer.complete(results.reduce((current, next) => 
              current.pingMs < next.pingMs ? current : next
          ));
        }
      }
    });

    // This will return the moment the completer triggers, 
    // either early (<7ms) or when all threads finish testing everything.
    return completer.future;
  }
}
