/* ==========================================================================
 * RCAC Upcoming Workshops banner
 * --------------------------------------------------------------------------
 * Notice strip under the homepage hero listing the next RCAC workshops.
 * Data source: the Halcyon CMS JSON API on the main RCAC website
 *   https://www.rcac.purdue.edu/api/news/types  (find the "events" type)
 *   https://www.rcac.purdue.edu/api/news        (articles of that type)
 *
 * No build step, no dependencies. Registered via `extra_javascript`
 * in mkdocs.yml. Compatible with Material's instant navigation.
 *
 * Behavior:
 *   - Only runs on pages containing #workshop-banner (the homepage,
 *     see overrides/main.html).
 *   - Lists Events whose headline starts with "[RCAC Workshop]", in
 *     ascending start order, until each session's end time.
 *   - Nothing upcoming / API unreachable -> the element stays hidden.
 *   - Markup options on #workshop-banner:
 *       data-variant="list" | "ticker"   (default "list")
 *       data-count="3"                   (rows in list mode)
 *       data-window="7"                  (list every session through
 *                                         23:59 of day N; overrides count)
 * ========================================================================== */

(function () {
  "use strict";

  var CONFIG = {
    apiBase: "https://www.rcac.purdue.edu/api",
    // Where "more" links go:
    trainingPage: "https://www.rcac.purdue.edu/training",
    // News type whose alias matches this pattern holds workshops:
    typeAliasPattern: /^events$/i,
    // Only show RCAC-run sessions; set false to show every Events item.
    requireHeadlinePrefix: true,
    headlinePrefix: /^\s*\[\s*RCAC\s+Workshop\s*\]\s*/i,
    lookaheadDays: 90,           // how far ahead to fetch sessions
    defaultCount: 3,             // rows in list mode when data-count is absent
    defaultDurationMinutes: 60,  // expiry for sessions with no end time
    cacheMinutes: 10,            // sessionStorage cache TTL
    timeZone: "America/Indiana/Indianapolis"
  };

  var ANCHOR_ID = "workshop-banner";
  var CACHE_KEY = "rcac-workshop-banner-v1";
  var TYPE_KEY = "rcac-workshop-typeid-v1";
  var DISMISS_KEY = "rcac-workshop-banner-dismissed";

  var CALENDAR_SVG =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
    '<path d="M19 19H5V8h14m-3-7v2H8V1H6v2H5c-1.11 0-2 .89-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2h-1V1m-1 11h-5v5h5v-5Z"/></svg>';

  /* ------------------------------------------------------------------ *
   * Time handling: Halcyon returns naive timestamps in Eastern time,
   * e.g. "2026-10-02 14:00:00". Convert to a real Date by computing the
   * Eastern UTC offset for that instant (same approach as outage-widget.js).
   * ------------------------------------------------------------------ */
  function parseEastern(str) {
    if (!str) return null;
    var m = String(str).match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})/);
    if (!m) return null;
    var asUTC = Date.UTC(+m[1], +m[2] - 1, +m[3], +m[4], +m[5], +m[6]);
    var offset = easternOffsetMs(new Date(asUTC));
    return new Date(asUTC - offset);
  }

  function easternParts(date) {
    var dtf = new Intl.DateTimeFormat("en-US", {
      timeZone: CONFIG.timeZone,
      hour12: false,
      year: "numeric", month: "2-digit", day: "2-digit",
      hour: "2-digit", minute: "2-digit", second: "2-digit"
    });
    var parts = {};
    dtf.formatToParts(date).forEach(function (p) { parts[p.type] = p.value; });
    return parts;
  }

  function easternOffsetMs(date) {
    try {
      var p = easternParts(date);
      var asIfUTC = Date.UTC(+p.year, +p.month - 1, +p.day,
        (+p.hour) % 24, +p.minute, +p.second);
      return asIfUTC - date.getTime();
    } catch (e) {
      return -5 * 3600 * 1000; // EST fallback
    }
  }

  // "YYYY-MM-DD" of the Eastern calendar day containing `date`.
  function easternDayKey(date) {
    try {
      var p = easternParts(date);
      return p.year + "-" + p.month + "-" + p.day;
    } catch (e) {
      return date.toISOString().slice(0, 10);
    }
  }

  // 23:59:59 Eastern on the day `days` after today.
  function endOfEasternDay(days) {
    var key = easternDayKey(new Date(Date.now() + days * 86400000));
    return parseEastern(key + " 23:59:59");
  }

  function fmt(date, opts) {
    var o = { timeZone: CONFIG.timeZone };
    Object.keys(opts).forEach(function (k) { o[k] = opts[k]; });
    try {
      return new Intl.DateTimeFormat("en-US", o).format(date);
    } catch (e) {
      delete o.timeZone;
      return new Intl.DateTimeFormat("en-US", o).format(date);
    }
  }

  // "2 PM" / "8:30 AM"
  function fmtTime(date) {
    return fmt(date, { hour: "numeric", minute: "2-digit" }).replace(":00", "");
  }

  function fmtMonthDay(date) {
    return fmt(date, { month: "short", day: "numeric" });
  }

  function isToday(date) {
    return easternDayKey(date) === easternDayKey(new Date());
  }

  // "Today · 2 – 3 PM" style meta text; start only when the CMS has no end.
  function fmtWhen(ev) {
    var start = ev.start;
    var s = fmtTime(start);
    if (ev.hasEnd && easternDayKey(ev.end) === easternDayKey(start)) {
      var e = fmtTime(ev.end);
      var sm = s.slice(-2), em = e.slice(-2);
      if (sm === em) s = s.slice(0, -3);
      s += " – " + e;
    }
    return s + " ET";
  }

  /* ------------------------------------------------------------------ *
   * Data fetching
   * ------------------------------------------------------------------ */
  function getCached() {
    try {
      var raw = sessionStorage.getItem(CACHE_KEY);
      if (!raw) return null;
      var obj = JSON.parse(raw);
      if (Date.now() - obj.t > CONFIG.cacheMinutes * 60 * 1000) return null;
      return obj.data;
    } catch (e) { return null; }
  }

  function setCached(data) {
    try {
      sessionStorage.setItem(CACHE_KEY, JSON.stringify({ t: Date.now(), data: data }));
    } catch (e) { /* storage full or unavailable — ignore */ }
  }

  function fetchJSON(url) {
    return fetch(url, { headers: { Accept: "application/json" } }).then(function (r) {
      if (!r.ok) throw new Error("HTTP " + r.status + " for " + url);
      return r.json();
    });
  }

  function resolveEventsTypeId() {
    try {
      var cached = JSON.parse(localStorage.getItem(TYPE_KEY) || "null");
      if (cached && Date.now() - cached.t < 24 * 3600 * 1000) {
        return Promise.resolve(cached.id);
      }
    } catch (e) { /* fall through to fetch */ }

    return fetchJSON(CONFIG.apiBase + "/news/types?limit=100").then(function (json) {
      var types = json.data || json;
      var match = (types || []).find(function (t) {
        return CONFIG.typeAliasPattern.test(t.alias || "");
      });
      if (!match) throw new Error("Events news type not found");
      try {
        localStorage.setItem(TYPE_KEY, JSON.stringify({ t: Date.now(), id: match.id }));
      } catch (e) { /* ignore */ }
      return match.id;
    });
  }

  // Returns plain, cacheable records (timestamps kept as CMS strings so
  // expiry is re-evaluated against the clock on every render).
  function fetchEvents() {
    var cached = getCached();
    if (cached) return Promise.resolve(cached);

    return resolveEventsTypeId()
      .then(function (typeId) {
        var url = CONFIG.apiBase + "/news?type=" + typeId +
          "&start=" + easternDayKey(new Date()) +
          "&limit=50&order=datetimenews&order_dir=asc";
        return fetchJSON(url);
      })
      .then(function (json) {
        var items = [];
        (json.data || []).forEach(function (a) {
          if (!a || a.published === 0 || !a.datetimenews) return;
          var headline = String(a.headline || "");
          if (CONFIG.requireHeadlinePrefix && !CONFIG.headlinePrefix.test(headline)) return;
          items.push({
            title: headline.replace(CONFIG.headlinePrefix, "").trim() || "Untitled session",
            start: a.datetimenews,
            end: a.datetimenewsend || null,
            location: String(a.location || "").trim(),
            detailUrl: a.uri || CONFIG.trainingPage,
            // Register on the RCAC news post, which carries the sign-up details.
            registerUrl: a.uri || CONFIG.trainingPage
          });
        });
        setCached(items);
        return items;
      });
  }

  // Parse, drop expired / far-future sessions, sort ascending by start.
  function upcoming(items) {
    var now = new Date();
    var horizon = new Date(now.getTime() + CONFIG.lookaheadDays * 86400000);
    return items.map(function (it) {
      var start = parseEastern(it.start);
      if (!start) return null;
      var end = parseEastern(it.end);
      var ev = {};
      Object.keys(it).forEach(function (k) { ev[k] = it[k]; });
      ev.start = start;
      ev.hasEnd = !!(end && end > start);
      ev.end = ev.hasEnd ? end
        : new Date(start.getTime() + CONFIG.defaultDurationMinutes * 60000);
      return ev;
    }).filter(function (ev) {
      return ev && ev.end > now && ev.start <= horizon;
    }).sort(function (a, b) { return a.start - b.start; });
  }

  /* ------------------------------------------------------------------ *
   * Rendering
   * ------------------------------------------------------------------ */
  function h(tag, attrs, children) {
    var el = document.createElement(tag);
    if (attrs) Object.keys(attrs).forEach(function (k) {
      if (k === "text") el.textContent = attrs[k];
      else if (k === "html") el.innerHTML = attrs[k];
      else el.setAttribute(k, attrs[k]);
    });
    (children || []).forEach(function (c) {
      if (c) el.appendChild(typeof c === "string" ? document.createTextNode(c) : c);
    });
    return el;
  }

  function sr(text) {
    return h("span", { class: "md-sr-only", text: text });
  }

  function link(href, cls, children) {
    // Every banner link leaves the docs site, so open it in a new tab.
    var attrs = { href: href, class: cls, target: "_blank", rel: "noopener noreferrer" };
    return h("a", attrs, children.concat([sr(" (opens in new tab)")]));
  }

  function moreLink(count, longForm) {
    var text = longForm
      ? count + " more on the training page →"
      : count + " more →";
    return link(CONFIG.trainingPage, "wb-more", [text]);
  }

  function todayBadge() {
    return h("span", { class: "wb-today", text: "Today" });
  }

  function meta(ev) {
    var parts = [isToday(ev.start) ? null : fmtMonthDay(ev.start), fmtWhen(ev)];
    if (ev.location) parts.push(ev.location);
    return parts.filter(Boolean).join(" · ");
  }

  function row(ev) {
    var today = isToday(ev.start);
    var chip = h("span", { class: "wb-chip", "aria-hidden": "true" }, [
      h("span", { class: "wb-chip-month", text: fmt(ev.start, { month: "short" }) }),
      h("span", { class: "wb-chip-day", text: fmt(ev.start, { day: "numeric" }) })
    ]);

    var title = link(ev.detailUrl, "wb-title", [
      sr((today ? "Today" : fmtMonthDay(ev.start)) + ": "),
      ev.title
    ]);
    title.setAttribute("title", ev.title);

    var main = h("div", { class: "wb-main" }, [
      title,
      h("span", { class: "wb-meta" }, [today ? todayBadge() : null, meta(ev)])
    ]);

    var register = link(ev.registerUrl, "wb-register", [
      "Register", sr(" for " + ev.title)
    ]);

    return h("li", { class: "wb-row" + (today ? " is-today" : "") }, [chip, main, register]);
  }

  function closeButton(el) {
    var btn = h("button", {
      class: "wb-close",
      type: "button",
      "aria-label": "Dismiss workshop notice",
      text: "✕"
    });
    btn.addEventListener("click", function () {
      el.hidden = true;
      try { sessionStorage.setItem(DISMISS_KEY, "1"); } catch (e) {}
    });
    return btn;
  }

  function icon() {
    return h("span", { class: "wb-icon", html: CALENDAR_SVG });
  }

  function renderList(el, shown, rest) {
    var head = h("div", { class: "wb-head" }, [
      h("span", { class: "wb-label", text: "Upcoming workshops" }),
      rest > 0 ? moreLink(rest, true) : null
    ]);
    var list = h("ul", { class: "wb-list" }, shown.map(row));
    return h("div", { class: "wb-body" }, [head, list]);
  }

  function renderTicker(el, next, rest) {
    var today = isToday(next.start);
    var when = (today ? "Today " : fmtMonthDay(next.start) + ", ") + fmtTime(next.start);
    return h("div", { class: "wb-body wb-ticker" }, [
      h("span", { class: "wb-label", text: "Next workshop" }),
      h("span", { class: "wb-when" + (today ? " is-today" : ""), text: when }),
      link(next.detailUrl, "wb-title", [next.title]),
      next.location ? h("span", { class: "wb-meta", text: next.location }) : null,
      rest > 0 ? moreLink(rest, false) : null
    ]);
  }

  function renderQuiet(el, days, next) {
    return h("div", { class: "wb-body wb-ticker" }, [
      h("span", { class: "wb-meta", text:
        "No sessions in the next " + days + (days === 1 ? " day." : " days.") }),
      h("span", { class: "wb-label", text: "Next:" }),
      h("span", { class: "wb-when", text: fmtMonthDay(next.start) }),
      link(next.detailUrl, "wb-title", [next.title]),
      link(CONFIG.trainingPage, "wb-more", ["All workshops →"])
    ]);
  }

  function render(el, items) {
    var events = upcoming(items);
    if (!events.length) { el.hidden = true; return; }

    var variant = el.getAttribute("data-variant") === "ticker" ? "ticker" : "list";
    var count = parseInt(el.getAttribute("data-count"), 10);
    if (!(count > 0)) count = CONFIG.defaultCount;
    var windowDays = parseInt(el.getAttribute("data-window"), 10);

    var shown = events.slice(0, count);
    var body;

    if (windowDays > 0) {
      var cutoff = endOfEasternDay(windowDays);
      shown = events.filter(function (ev) { return ev.start <= cutoff; });
      if (!shown.length) body = renderQuiet(el, windowDays, events[0]);
    }

    if (!body) {
      var rest = events.length - (variant === "ticker" ? 1 : shown.length);
      body = variant === "ticker"
        ? renderTicker(el, shown[0], rest)
        : renderList(el, shown, rest);
    }

    el.textContent = "";
    el.setAttribute("data-state", body.classList.contains("wb-ticker") ? "line" : "list");
    el.appendChild(icon());
    el.appendChild(body);
    el.appendChild(closeButton(el));
    el.hidden = false;
  }

  /* ------------------------------------------------------------------ *
   * Bootstrapping (works with and without navigation.instant)
   * ------------------------------------------------------------------ */
  function dismissed() {
    try { return sessionStorage.getItem(DISMISS_KEY) === "1"; } catch (e) { return false; }
  }

  function init() {
    var el = document.getElementById(ANCHOR_ID);
    if (!el || el.getAttribute("data-ready") === "1") return;
    el.setAttribute("data-ready", "1");
    if (dismissed()) return;

    fetchEvents()
      .then(function (items) { render(el, items); })
      .catch(function (err) {
        // Fail quietly: the homepage must never break because the
        // events API is unreachable.
        console.warn("[workshop-banner]", err);
        el.hidden = true;
      });
  }

  if (window.document$ && typeof window.document$.subscribe === "function") {
    // Material instant navigation: fires on initial load and every page swap.
    window.document$.subscribe(init);
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
