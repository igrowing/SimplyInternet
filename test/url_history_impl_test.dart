import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/features/urlcheck/data/repositories/url_history_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late UrlHistoryImpl history;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    history = UrlHistoryImpl(prefs);
  });

  test('starts empty', () {
    expect(history.entries(), isEmpty);
  });

  test('remembers an address and keeps it across instances', () async {
    await history.remember('example.com');
    expect(history.entries(), ['example.com']);
    expect(UrlHistoryImpl(prefs).entries(), ['example.com']);
  });

  test('newest entry comes first', () async {
    await history.remember('a.com');
    await history.remember('b.com');
    expect(history.entries(), ['b.com', 'a.com']);
  });

  test(
    're-checking an address moves it back to the front without duplicating',
    () async {
      await history.remember('a.com');
      await history.remember('b.com');
      await history.remember('A.COM');
      expect(history.entries(), ['A.COM', 'b.com']);
    },
  );

  test('a blank string is ignored', () async {
    await history.remember('   ');
    await history.remember('');
    expect(history.entries(), isEmpty);
  });

  test('the stored address is trimmed', () async {
    await history.remember('  example.com  ');
    expect(history.entries(), ['example.com']);
  });

  test('the list is capped at 15 entries, dropping the oldest', () async {
    for (var i = 0; i < 20; i++) {
      await history.remember('site$i.com');
    }
    final entries = history.entries();
    expect(entries.length, 15);
    expect(entries.first, 'site19.com');
    expect(entries.last, 'site5.com');
  });
}
