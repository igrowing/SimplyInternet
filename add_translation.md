# Adding a language to SimplyInternet

The whole app is translatable: the chrome (buttons, settings, snackbars), the
diagnosis verdicts and their advice, and the copy‑paste *Technical details* log
all come from one set of translation files.

This guide walks through adding a **new language**. There is a shorter section at
the end for adding **a single new string** to the languages that already exist.

---
## Top level process
1. Fork.
2. Translate, as described below. Including the test ;)
3. Create PR. The unit tests (CI pipeline) must pass.
4. Get your name credited as contributor!

---

## How the translations are organised

| Thing | Where |
|---|---|
| Translation files (one per language) | `lib/l10n/app_<code>.arb` |
| Source of truth (English, with descriptions) | `lib/l10n/app_en.arb` |
| Generator config | `l10n.yaml` |
| Generated Dart — **git-ignored, never edited or committed** | `lib/l10n/app_localizations*.dart` |
| Language picker list | `lib/features/settings/domain/entities/app_language.dart` |
| Wiring into the app | `lib/main.dart` (`AppLocalizations.supportedLocales`) |

`.arb` is plain JSON. Each entry is `"key": "translated text"`. Only
`app_en.arb` carries the `"@key": { "description": ... }` blocks — other
languages just need the `"key": "value"` pairs.

The generated `AppLocalizations` and the app's `supportedLocales` are built
**automatically** from whatever `app_*.arb` files exist, so once your file is in
place and `flutter gen-l10n` has run, the locale is live.

The `lib/l10n/app_localizations*.dart` files are build output and are **not in
git** (`.gitignore` excludes them). `flutter pub get` regenerates them, so they
appear in your working tree but never in a diff or a PR — commit only the `.arb`
files. If your editor shows "undefined" errors on `AppLocalizations` right after
a fresh clone, run `flutter pub get` once.

---

## Rules for translating a value

1. **Translate whole sentences.** Never build a sentence by gluing pieces
   together — word order and grammar differ per language. Each key already holds
   a complete sentence.
2. **Keep every `{placeholder}` exactly as it is**, but move it to where it
   belongs in your language. Examples: `{where}`, `{gateway}`, `{hop}`,
   `{medium}`, `{uses}`, `{failing}`, `{measured}`, `{value}`, `{count}`,
   `{received}`, `{sent}`.
3. **Keep ICU `select` / `plural` structure.** Translate only the text inside
   each `{...}` branch, never the branch keywords or the variable name:

   ```
   "mediumLabel": "{kind, select, wifi{Wi-Fi} mobile{mobile data} ethernet{wired connection} vpn{VPN connection} other{connection}}"
   ```

   Here you translate `Wi-Fi`, `mobile data`, … but leave
   `{kind, select, wifi{…} mobile{…} … other{…}}` intact. The keys with
   `select` are: `mediumLabel`, `useCaseName`, `solutionMobileNoDataReception`.
4. **Leave units, numbers and emoji alone**: `Mbps`, `ms`, `%`, `1.1.1.1`,
   `✅ ❌ ✈️ ⚠️`.
5. **Keep `\n` line breaks** where they appear (the numbered how‑to‑fix lists).
6. Brand / protocol names stay as‑is: `Wi-Fi`, `DNS`, `VPN`, `DSL`, `ISP`,
   `Cloudflare`, `Google`, `traceroute`.

---

## Step by step: add a new language

Example: **Dutch**, language code `nl`.

### 1. Create the translation file

Copy the English file and translate it:

```bash
cp lib/l10n/app_en.arb lib/l10n/app_nl.arb
```

In `app_nl.arb`:

- change `"@@locale": "en"` to `"@@locale": "nl"`;
- translate every `"key": "value"` following the rules above;
- delete the `"@key": { ... }` description blocks (optional, but keeps the file
  small — only `app_en.arb` needs them).

For a script‑specific variant (like Simplified vs Traditional Chinese) name the
file `app_<lang>_<Script>.arb`, e.g. `app_zh_Hant.arb`, and set
`"@@locale": "zh_Hant"`.

### 2. Add the language to the picker

Edit `lib/features/settings/domain/entities/app_language.dart` and add an entry
to `AppLanguage.supported` (the list is in display order):

```dart
AppLanguage(locale: Locale('nl'), countryCode: 'NL', endonym: 'Nederlands'),
```

- `locale` — the language code (use `Locale.fromSubtags(languageCode: 'zh',
  scriptCode: 'Hant')` for script variants);
- `countryCode` — an ISO country code, used only to pick the flag icon shown
  next to the name (a flag stands in for the language, so a couple of entries
  deliberately share one);
- `endonym` — the language's own name for itself (`Nederlands`, `Deutsch`,
  `日本語`), shown regardless of the current UI language.

### 3. Regenerate

```bash
flutter gen-l10n
```

(`flutter pub get` also runs it, because `pubspec.yaml` has `generate: true`.)

This:

- validates that `app_nl.arb` parses and that every placeholder matches the
  template;
- regenerates `lib/l10n/app_localizations*.dart` (git-ignored — leave them out
  of your commit);
- reports how many messages are still untranslated per language.

If it lists untranslated messages for `nl`, add a temporary line to `l10n.yaml`:

```yaml
untranslated-messages-file: missing.txt
```

run `flutter gen-l10n` again to get the exact list in `missing.txt`, fill those
keys, then remove the line.

### 4. Add a smoke test

In `test/localization_wiring_test.dart` there is a map of
`languageCode: expectedText` spot checks. Add one line with the translation of
**"Check it"** (the home‑screen button):

```dart
'nl': 'Controleren',
```

This proves the picker → `MaterialApp.locale` → rendered text path works for the
new locale.

### 5. Check it builds and passes

```bash
flutter analyze
flutter test
```

`flutter analyze` must be clean and every test must pass.
`test/verdict_localization_test.dart` runs a full fake diagnosis through a
non‑English locale — a good template if you want to assert your language's
verdict wording too.

### 6. See it in the app (optional but recommended)

```bash
flutter run
```

Open **Settings → Language**, pick the new language, then run a diagnosis and
open **Technical details** — the verdict, the *What to do* card and the log
should all be in your language.

---

## Adding a single new string (for all existing languages)

When you add a feature that needs new user‑facing text:

1. Add the key to **`lib/l10n/app_en.arb`** with an `"@key"` description block,
   declaring any placeholders and their types:

   ```json
   "myNewMessage": "Checked {count} sites",
   "@myNewMessage": {
     "description": "Shown after the popular-site sweep.",
     "placeholders": { "count": { "type": "int" } }
   }
   ```

2. Add the translated `"myNewMessage": "..."` line to **every other
   `lib/l10n/app_*.arb`** file (16 of them). If you can't translate them all,
   still add the key with the English text as a placeholder so the build stays
   green, and note it in your PR for native speakers to finish.

3. `flutter gen-l10n`, then use it as `AppLocalizations.of(context).myNewMessage`
   (or `l10n.myNewMessage(count)` when it has placeholders). In the diagnosis
   engine the object is passed in — see `AppLocalizations l10n` parameters in
   `run_diagnosis.dart` and `verdict_catalog.dart`.

4. `flutter analyze && flutter test`.

---

## Currently supported languages

Czech, German, English, Spanish, French, Hindi, Italian, Japanese, Korean,
Polish, Portuguese, Russian, Thai, Ukrainian, Chinese (Simplified), Chinese
(Traditional).

Machine‑assisted translations are welcome as a starting point, but a review by a
native speaker before release is what makes them ship‑quality — say in your PR
which languages you can vouch for.
