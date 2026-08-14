# Privacy Policy — SimplyInternet

**Last updated: August 5, 2026**

SimplyInternet is an open-source Internet connection diagnostics app developed
by [igrowing](https://github.com/igrowing/SimplyInternet). This policy
explains what data the app accesses, why, and what it does (and does not) do
with it.

---

## 1. Summary (TL;DR)

- SimplyInternet **does not collect, store, transmit, or share any personal
  data**.
- The app has **two functions**: diagnosing your connection, and checking
  whether a specific website is reachable. Both run **only when you tap the
  button** — nothing happens in the background.
- Diagnostic checks are sent to a handful of well-known, independent Internet
  services (listed below) so the app can tell you what's actually wrong.
  These services see only technical connection data, never anything that
  identifies you personally.
- There are **no ads, no analytics, no tracking, no telemetry, no accounts**.
- The app is **open source** — you can inspect every line of code at
  [github.com/igrowing/SimplyInternet](https://github.com/igrowing/SimplyInternet).

---

## 2. Permissions and Why They Are Used

SimplyInternet requests far fewer permissions than a typical network tool,
because it only diagnoses your connection — it does not scan your LAN, does
not run background services, and does not send notifications.

### Location (ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION)

Android requires the **Location** permission for any app that reads Wi-Fi
network details (such as the router/gateway IP address) via the OS Wi-Fi
APIs. This is an Android platform policy, not a choice made by SimplyInternet
— the app cannot ask the OS for this information without the permission
being granted.

SimplyInternet uses this permission **only** to:

- Detect your router's gateway IP address, so it can check whether your
  device can reach your own router.

The app **never** derives your physical location from this permission. It
does not use GPS, does not request your coordinates, and does not record,
transmit, or log your location.

### Network / Internet Access (INTERNET, ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE)

Required to check your connection type (Wi-Fi/mobile/none), reach your
router, and run the diagnostic and website-check probes described below. All
of these operations are initiated explicitly by you, by tapping "Find the
problem" or "Check it". Results are displayed on screen only.

SimplyInternet does **not** request `CHANGE_WIFI_STATE`, does **not** run a
foreground service, and does **not** request notification permission — it
has no background or persistent processes.

---

## 3. What Happens When You Tap a Button

### "Find the problem and give solution"

Runs a series of connectivity checks: connection type, reachability of your
router, generic 204 "connectivity check" endpoints (Google's
`connectivitycheck.gstatic.com` and Cloudflare's `cp.cloudflare.com`), a
public-IP/country lookup via Cloudflare's trace endpoint
(`www.cloudflare.com/cdn-cgi/trace`), reachability of a few popular sites, DNS
resolution, and an optional speed test against Cloudflare
(`speed.cloudflare.com`).

None of these requests include your name, account details, or any identifier
beyond your device's public IP address — which is inherent to how the
Internet works and is visible to any server you contact, with or without this
app.

If the app suggests a fix that changes a setting on your phone (for example,
enabling Wi-Fi), it only does so **after you explicitly confirm**.

### "Check it" — is this website down?

You paste a URL and tap **Check it**. SimplyInternet then:

- Fetches the page directly from your device to check if it loads.
- Resolves the domain via DNS.
- Looks up basic domain registration facts (existence, expiry) via the RDAP
  service at `rdap.org`.
- Cross-checks reachability from multiple locations worldwide via
  `check-host.net`.
- Cross-checks whether the site is reported down for others via the
  independent outage-tracking service `websitedown.org`.

The **only data sent** to these third-party services is the URL/domain you
typed and your device's public IP address (unavoidable for any Internet
request). No other data about you or your device is included.

---

## 4. Data Storage

SimplyInternet stores only **one small setting on your device**:

| What | Where | Why |
|------|-------|-----|
| Light/dark theme preference | Android SharedPreferences | Remember your chosen theme across app launches |

No scan logs, diagnostic history, or checked URLs are saved. No data is
stored in the cloud. No account is required. No registration. Uninstalling
the app removes all stored data.

---

## 5. Third-Party Services and Libraries

To diagnose your connection, SimplyInternet contacts the following
**independent, well-known Internet services**. Each request contains only
the technical data described in Section 3 above (never your name, contacts,
files, or anything else on your device):

| Service | Purpose |
|---------|---------|
| [Google connectivity check](https://developers.google.com/speed/public-dns) (`connectivitycheck.gstatic.com`) | Detect captive portals / generic Internet reachability |
| [Cloudflare](https://www.cloudflare.com/) (`cp.cloudflare.com`, `cdn-cgi/trace`, `speed.cloudflare.com`) | Connectivity check, public IP/country lookup, speed test |
| [RDAP / rdap.org](https://rdap.org/) | Domain registration lookup |
| [check-host.net](https://check-host.net/) | Multi-location reachability check |
| [websitedown.org](https://websitedown.org/) | Independent outage cross-check |

SimplyInternet uses the following **open-source libraries**. None of them
collect, transmit, or process personal data beyond what's described above.
All are distributed under permissive open-source licenses.

| Library | License | Purpose |
|---------|---------|---------|
| [Flutter](https://flutter.dev) | BSD 3-Clause | UI framework |
| [provider](https://pub.dev/packages/provider) | MIT | State management |
| [get_it](https://pub.dev/packages/get_it) | MIT | Dependency injection |
| [equatable](https://pub.dev/packages/equatable) | MIT | Value equality for domain models |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | BSD 3-Clause | Local theme setting storage |
| [connectivity_plus](https://pub.dev/packages/connectivity_plus) | BSD 3-Clause | Detect connection type (Wi-Fi/mobile/none) |
| [network_info_plus](https://pub.dev/packages/network_info_plus) | BSD 3-Clause | Read router gateway IP |
| [package_info_plus](https://pub.dev/packages/package_info_plus) | BSD 3-Clause | Show app version on the main screen |
| [url_launcher](https://pub.dev/packages/url_launcher) | BSD 3-Clause | Open captive-portal / website links in your browser |
| [http](https://pub.dev/packages/http) | BSD 3-Clause | Diagnostic and website-check network requests |

There are **no third-party advertising SDKs**, **no crash reporting
services**, and **no analytics platforms** integrated in SimplyInternet.

---

## 6. Children's Privacy

SimplyInternet is a general-audience utility app. It does not target children
and does not knowingly collect any data from anyone.

---

## 7. Changes to This Policy

If the app ever changes in a way that affects privacy (e.g., a new permission
or a new third-party service is added), this policy will be updated and the
"Last updated" date will change. The policy is always available at:
[https://raw.githubusercontent.com/igrowing/SimplyInternet/refs/heads/main/PRIVACY_POLICY.md](https://raw.githubusercontent.com/igrowing/SimplyInternet/refs/heads/main/PRIVACY_POLICY.md)

---

## 8. Contact

Questions about this privacy policy:
[GitHub Issues](https://github.com/igrowing/SimplyInternet/issues) or open a
discussion at the repository above.
