# SimplyInternet

**Full Wi-Fi bars but nothing loads? One tap and SimplyInternet tells you exactly what's broken — in plain words — and what to do about it.**

No jargon. No guessing. No helpless confusion. No embarrassing calls. 🎉

---

## Two buttons. Two superpowers.

### 1️⃣ "Find the problem and give solution" — the whole-Internet check-up

Tap the big button, sit back for a few seconds, and the app quietly runs the same checks a network engineer would. Then it hands you **one clear answer** — never a wall of numbers:

- 📶 Wi-Fi or mobile data is simply off
- 📡 Your router isn't answering
- 🔑 A hotel/café "sign-in" page is holding you hostage
- 🌐 Router's fine — your provider's Internet isn't
- 🧭 A name-lookup (DNS) hiccup — often fixed in one tap
- 🚫 Something is blocking a connection (a port or firewall)
- ✅ Everything works — and here's what it's good for

And when nothing is broken, the app doesn't just shrug and say "all clear". It measures your download and upload speed, how fast your connection answers, how steady that is (jitter) and how much it drops (packet loss) — then tells you what you can actually **do** with it:

- 💚 *"Your Wi-Fi is good for video calls, HD films, gaming and everything else"*
- 💛 *"Good for everything, except 4K films and fast online games"*
- 🧡 *"Too weak for video calls and HD films"* — with the reason, and what to try

Because a connection can be perfectly "connected" and still ruin your meeting. And if your video call won't hold but your voice will, it says so: *"turn your camera off — your connection can still carry the audio."*

It never leaves you hanging: every problem comes with **what to do next**. When the app can fix it itself, it asks first — *"Wi-Fi is off. Turn it on?"* — and only acts when you say yes. You're always in charge. 💪

### 2️⃣ "Check it" — is this one website down, or is it just me?

One site or app misbehaving? Paste its link, tap **Check it**, and the detective work happens in the background:

- Does the site actually load for you, right now?
- What does that error *really* mean — "access denied", "page not found", "too many requests", "their server is broken" — and what can **you** do about it?
- Does the web address even exist, or has it expired?
- Is its security certificate still valid?
- Is it **down for everyone, or only for you?** Cross-checked against an independent worldwide outage service, so you get a trustworthy second opinion.
- Is it blocked in your region — or does it just need a special "port"?

Finally, a straight answer to the eternal question: *"Is it broken, or is it me?"*

---

## Why you'll want this on your phone 🚀

Every one of us has been there: the video freezes mid-sentence, the payment page won't load, the video call drops right before you speak. And then comes the worst part — the *not knowing*. Rebooting the router for the third time. Unplugging cables at random. Waiting on hold with your provider only to be asked, again, whether you've tried turning it off and on.

Stop guessing. **SimplyInternet turns five minutes of frustrated poking into five seconds of certainty.** You'll know whether to restart the router, sign in to the café Wi-Fi, switch your DNS, call your provider — or simply relax, because the website is down and there is genuinely nothing to fix on your side.

That's a real superpower. You'll be on the control of what happens. 😎

It's free, it's tiny, it asks for nothing, and it changes nothing on your phone without your permission. Install it now — and the next time the Internet acts up, you'll be ready.

**One tap. Real answers. Get SimplyInternet.** ⚡

---

## Ideally for:

- 👵 **Parents and grandparents** who just want the Internet to work — without a lecture full of tech terms.
- 🧑‍💼 **Anyone working or studying from home** who needs to know *fast* whether it's their Wi-Fi, their provider, or the website itself.
- ✈️ **Travellers** wrestling with hotel, café, and airport Wi-Fi and its mysterious sign-in pages.
- 🧑‍🔧 **The "family IT person"** who wants a quick, reliable read before rolling up their sleeves.
- 🙋 **Everyone** who has ever stared at a full signal icon and wondered why nothing is loading.

---

## Your privacy

SimplyInternet runs its checks to help you — it doesn't collect your personal data. Any action that changes a setting on your phone happens only after you confirm it.

**About mobile data.** Measuring speed means moving real data (roughly 5–15 MB, depending on how fast your line is). The app measures whatever connection your phone is already using, and never switches it for you, so your mobile data is only used when:

1. Wi-Fi is not connected — mobile data *is* your Internet, so that's what gets tested; or
2. you tested over Wi-Fi and then chose to repeat the test over mobile data.

The app never quietly runs a speed test over mobile data while Wi-Fi is working, and never runs one in the background — checks only happen when you tap a button.

---

## How it works

### "Find the problem and give solution"

The app asks the same questions a network engineer would, **in the same order**, and stops at the first one that answers. That order is what makes the app fast and its answers unambiguous: the very first thing that is genuinely broken is the thing you get told about, and you never receive two competing explanations for one failure.

**1. Is there a link at all?** Flight mode on, or Wi-Fi and mobile data both off — answered instantly from the phone itself, before a single packet is sent.

**2. The reachability gate.** Four checks run at the same time, so this stage costs one timeout rather than four:

- your **router** is pinged (and if it ignores ICMP, a TCP knock on port 80/443 stops an ordinary firewall being mistaken for a dead router);
- two **captive-portal probes** (`connectivitycheck.gstatic.com` and `cp.cloudflare.com`) ask for an empty "204 No Content" answer — anything else, a redirect or a login page, is the signature of a hotel/café sign-in wall;
- **raw IP addresses** (1.1.1.1, 8.8.8.8, 9.9.9.9) are contacted by IP only, which works even when name lookup is dead;
- a **name lookup** for `cloudflare.com`.

Those four facts are then read through a fixed ladder — router → sign-in page → Internet reachable → raw IP vs. DNS → route to the Internet → mobile data. Each rung has its own plain-language verdict, and the app stops there. Only when the ladder cannot decide between "your provider's line is out" and "the route dies somewhere upstream" does it spend the ~20 seconds a route trace costs.

**3. The measurements** — started only once the link is proven usable, because measuring a dead line is pointless:

- **common ports** (HTTPS 443, HTTP 80, DNS 53) — some open and some blocked means a firewall, not an outage;
- a **route trace** towards 1.1.1.1, to see whether the path leaves your provider's network;
- **real websites**, chosen for the country you are actually in (detected via Cloudflare's trace endpoint) plus a baseline from every continent — anycast IPs answering is not proof that the web works;
- **latency, jitter and packet loss**, from 10 ICMP samples to your router and 10 to the Internet;
- **download and upload speed**, from Cloudflare's public speed service — 5 seconds down, 3 seconds up, time-boxed rather than size-boxed so a slow line reports its real rate instead of timing out. Latency is sampled *again* while the transfer is running: if it balloons under load, your line buffers badly, which is exactly why calls stutter while someone else is streaming.

The idle latency samples deliberately finish **before** the speed test starts — saturating the line first would spoil the very baseline the busy figure is compared against.

**4. What it can actually do.** With nothing broken, the app doesn't stop at "all clear". The measured figures are matched against what ten everyday activities need — music, voice calls, browsing, 720p and HD video calls, team games, fast online games, 1080p, 4K — each with its own download, upload, latency, jitter and loss limits. Nothing fails ⇒ *good*; up to three fail ⇒ *good for everything except…*; more ⇒ *degraded*, named with the reason. A metric that could not be measured is skipped, never assumed to pass. And because "voice calls" is judged separately from "video calls", the app can tell you to switch the camera off rather than just declaring the call impossible.

**5. The answer, and what to do.** Every verdict carries its solution, and where the app can help it offers a button — open flight-mode settings, open Wi-Fi settings, open the sign-in page, test again. Each one asks first and only acts when you agree; nothing on your phone is changed behind your back. Android does not permit an app to switch between Wi-Fi and mobile data, so "test over the other one" sends you to the Wi-Fi panel and re-runs the test by itself the moment you return.

Every run also records **exactly which tests it performed, against which targets, and how many bytes each one moved** — including the runs that stopped early. That is the *Technical details* view, and it is copyable in full, so you have something concrete to send your provider.

### "Check it"

Here everything runs **at once**, because none of the checks depends on another:

- the page is **fetched** from your device (12-second limit), keeping the status code, the redirect chain, how long it took, and any `Retry-After` the server asked for;
- the **name is looked up**;
- the **registration** is read from RDAP (`rdap.org`) — does the domain exist, has it expired, when does it lapse;
- the **web ports** 80, 443, 8080 and 8443 are knocked on, to spot a service listening somewhere unusual;
- the **HTTPS certificate** is validated by a real handshake; if that fails, a second, deliberately tolerant handshake reads the certificate anyway, so the app can say *why* it was rejected instead of just "failed";
- the site is opened **from up to 12 other countries** via check-host.net;
- an **independent outage service** (websitedown.org) is asked for its own regional verdict, and for a near-miss hostname — the missing or extra `www.`.

Then the same principle as the other button: the evidence is reconciled into **one** conclusion, by strength of proof, and the first match wins.

1. **A bad certificate outranks everything** — even on a page that loaded, it is the one thing you must know before typing a password.
2. **The page loaded** → it works. If other countries were refused, you are told that too, as one message, not two.
3. **The server answered with an error** → its own status code is the reason, and no outside opinion may overrule a reply we are holding: 401 sign in, 403 refused, 404 no such page, 408 timed out, 429 too many requests (quoting the site's own wait), 451 legally blocked, 5xx their server is broken.
4. **It answers others but not you** → blocked on your connection or in your country.
5. **The name resolves nowhere, and nothing else suggests it exists** → the address doesn't exist.
6. **The registration lapsed** → the owner must renew it; nothing on your side will help.
7. **Down from everywhere too** → down for everyone. Wait it out.
8. Otherwise → the address exists but the server isn't answering.

That "nothing else suggests it exists" in step 5 matters: a registry lookup that simply doesn't cover a country's domains must never be allowed to declare a live website non-existent, so the app requires *every* source to agree before saying an address is wrong.

On top of the conclusion, only genuinely extra facts get a mention: a site that answered but took over 8 seconds, a `www.` variant that does work, a service found on an alternate port, or a registration expiring within a month. Explanation and instruction are kept strictly apart — the reasons go in the findings, everything you could *do* collects in a single **What to do** list. The full technical log, every vantage point included, is there to copy as well.

---

## How to contribute

* [Open an issue](https://github.com/igrowing/SimplyInternet/issues) if you found a bug or want a new feature.
* **Translate the app into your language** — the whole app, verdicts included, is translatable. See [add_translation.md](add_translation.md) for step-by-step instructions.
* If you like the app and it makes your life a bit simpler <br><a href="https://www.buymeacoffee.com/igrowing" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
