/* ==========================================================================
 * RCAC System Status / Outage Widget
 * --------------------------------------------------------------------------
 * Floating status pill for the RCAC-Docs MkDocs Material site.
 * Data source: the Halcyon CMS JSON API on the main RCAC website
 *   https://www.rcac.purdue.edu/api/news        (articles)
 *   https://www.rcac.purdue.edu/api/news/types  (news types)
 *
 * No build step, no dependencies. Registered via `extra_javascript`
 * in mkdocs.yml. Compatible with Material's instant navigation.
 *
 * Behavior:
 *   - By default the widget only appears on pages containing an element
 *     with id="outage-widget-anchor" (the homepage). Set
 *     CONFIG.homepageOnly = false to show it on every page.
 *   - Green  = no active or upcoming items
 *   - Amber  = maintenance/outage scheduled within `upcomingWindowDays`
 *   - Red    = outage/maintenance active right now
 * ========================================================================== */

(function () {
  "use strict";

  var CONFIG = {
    apiBase: "https://www.rcac.purdue.edu/api",
    // Where "view all" links go:
    newsPage: "https://www.rcac.purdue.edu/news/outages-and-maintenance",
    // News type whose alias matches this pattern is treated as outage news:
    typeAliasPattern: /outage/i,
    homepageOnly: true,          // require #outage-widget-anchor on the page
    upcomingWindowDays: 14,      // how far ahead to surface scheduled work
    staleActiveDays: 7,          // open-ended items older than this are ignored
    cacheMinutes: 5,             // sessionStorage cache TTL
    refreshMinutes: 5,           // background refresh while page is open
    maxItems: 5,                 // max entries listed in the panel
    timeZone: "America/Indiana/Indianapolis"
  };

  var CACHE_KEY = "rcac-outage-widget-v1";
  var TYPE_KEY = "rcac-outage-typeid-v1";
  var OPEN_KEY = "rcac-outage-widget-open";
  var refreshTimer = null;

  /* ------------------------------------------------------------------ *
   * Time handling: Halcyon returns naive timestamps in Eastern time,
   * e.g. "2026-06-09 10:00:00". Convert to a real Date in the user's
   * local clock by computing the Eastern UTC offset for that instant.
   * ------------------------------------------------------------------ */
  function parseEastern(str) {
    if (!str) return null;
    var m = String(str).match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})/);
    if (!m) return null;
    // Pretend the wall-clock time is UTC, then correct by the zone offset.
    var asUTC = Date.UTC(+m[1], +m[2] - 1, +m[3], +m[4], +m[5], +m[6]);
    var offset = easternOffsetMs(new Date(asUTC));
    return new Date(asUTC - offset);
  }

  function easternOffsetMs(date) {
    try {
      var dtf = new Intl.DateTimeFormat("en-US", {
        timeZone: CONFIG.timeZone,
        hour12: false,
        year: "numeric", month: "2-digit", day: "2-digit",
        hour: "2-digit", minute: "2-digit", second: "2-digit"
      });
      var parts = {};
      dtf.formatToParts(date).forEach(function (p) { parts[p.type] = p.value; });
      var asIfUTC = Date.UTC(
        +parts.year, +parts.month - 1, +parts.day,
        (+parts.hour) % 24, +parts.minute, +parts.second
      );
      return asIfUTC - date.getTime();
    } catch (e) {
      return -5 * 3600 * 1000; // EST fallback
    }
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

  function resolveOutageTypeId() {
    try {
      var cached = JSON.parse(localStorage.getItem(TYPE_KEY) || "null");
      if (cached && Date.now() - cached.t < 24 * 3600 * 1000) {
        return Promise.resolve(cached.id);
      }
    } catch (e) { /* fall through to fetch */ }

    return fetchJSON(CONFIG.apiBase + "/news/types?limit=100").then(function (json) {
      var types = json.data || json;
      var match = (types || []).find(function (t) {
        return CONFIG.typeAliasPattern.test(t.alias || "") ||
               CONFIG.typeAliasPattern.test(t.name || "");
      });
      if (!match) throw new Error("Outage news type not found");
      try {
        localStorage.setItem(TYPE_KEY, JSON.stringify({ t: Date.now(), id: match.id }));
      } catch (e) { /* ignore */ }
      return match.id;
    });
  }

  function fetchStatus() {
    var cached = getCached();
    if (cached) return Promise.resolve(cached);

    return resolveOutageTypeId()
      .then(function (typeId) {
        var url = CONFIG.apiBase + "/news?type=" + typeId +
          "&limit=25&order=datetimecreated&order_dir=desc";
        return fetchJSON(url);
      })
      .then(function (json) {
        var data = classify(json.data || []);
        setCached(data);
        return data;
      });
  }

  /* ------------------------------------------------------------------ *
   * Classification
   * ------------------------------------------------------------------ */
  function classify(articles) {
    var now = new Date();
    var horizon = new Date(now.getTime() + CONFIG.upcomingWindowDays * 86400000);
    var staleCutoff = new Date(now.getTime() - CONFIG.staleActiveDays * 86400000);
    var active = [], upcoming = [];

    articles.forEach(function (a) {
      if (!a || a.published === 0) return;
      var start = parseEastern(a.datetimenews);
      var end = parseEastern(a.datetimenewsend);
      if (!start) return;

      var item = {
        headline: a.headline || "Untitled",
        date: a.formatteddate || "",
        url: a.uri || CONFIG.newsPage,
        resources: (a.resources || [])
          .map(function (x) { return x && (x.name || x.associd); })
          .filter(Boolean)
      };

      if (start <= now) {
        if (end ? end >= now : start >= staleCutoff) active.push(item);
      } else if (start <= horizon) {
        upcoming.push(item);
      }
    });

    return {
      active: active.slice(0, CONFIG.maxItems),
      upcoming: upcoming.slice(0, CONFIG.maxItems),
      checked: now.toISOString()
    };
  }

  /* ------------------------------------------------------------------ *
   * Rendering
   * ------------------------------------------------------------------ */
  function h(tag, attrs, children) {
    var el = document.createElement(tag);
    if (attrs) Object.keys(attrs).forEach(function (k) {
      if (k === "text") el.textContent = attrs[k];
      else el.setAttribute(k, attrs[k]);
    });
    (children || []).forEach(function (c) { el.appendChild(c); });
    return el;
  }

  function removeWidget() {
    var existing = document.getElementById("rcac-outage-widget");
    if (existing) existing.remove();
    if (refreshTimer) { clearInterval(refreshTimer); refreshTimer = null; }
  }

  function render(status) {
    removeWidget();

    var level = status.active.length ? "error"
              : status.upcoming.length ? "warn"
              : "ok";

    var label = level === "error"
      ? (status.active.length === 1 ? "1 active outage"
         : status.active.length + " active outages")
      : level === "warn"
        ? "Maintenance scheduled"
        : "All systems normal";

    var root = h("div", { id: "rcac-outage-widget", "data-level": level });

    /* --- panel --------------------------------------------------- */
    var panel = h("div", {
      class: "rcac-ow-panel",
      role: "dialog",
      "aria-label": "RCAC system status",
      hidden: ""
    });

    panel.appendChild(h("div", { class: "rcac-ow-head" }, [
      h("span", { class: "rcac-ow-title", text: "System status" }),
      h("button", {
        class: "rcac-ow-close",
        type: "button",
        "aria-label": "Close status panel",
        text: "\u00d7"
      })
    ]));

    var body = h("div", { class: "rcac-ow-body" });

    function section(titleText, items, cls) {
      body.appendChild(h("p", { class: "rcac-ow-section " + cls, text: titleText }));
      var ul = h("ul", { class: "rcac-ow-list" });
      items.forEach(function (it) {
        var a = h("a", { href: it.url, target: "_blank", rel: "noopener" });
        a.appendChild(h("span", { class: "rcac-ow-item-title", text: it.headline }));
        var meta = it.date;
        if (it.resources.length) {
          meta += (meta ? " \u00b7 " : "") + it.resources.slice(0, 6).join(", ");
        }
        if (meta) a.appendChild(h("span", { class: "rcac-ow-item-meta", text: meta }));
        ul.appendChild(h("li", null, [a]));
      });
      body.appendChild(ul);
    }

    if (status.active.length) section("Happening now", status.active, "is-error");
    if (status.upcoming.length) {
      section("Upcoming (next " + CONFIG.upcomingWindowDays + " days)",
        status.upcoming, "is-warn");
    }
    if (!status.active.length && !status.upcoming.length) {
      body.appendChild(h("p", {
        class: "rcac-ow-empty",
        text: "No outages reported and no maintenance scheduled in the next " +
              CONFIG.upcomingWindowDays + " days."
      }));
    }

    panel.appendChild(body);
    panel.appendChild(h("div", { class: "rcac-ow-foot" }, [
      h("a", {
        href: CONFIG.newsPage, target: "_blank", rel: "noopener",
        text: "All outages & maintenance \u2192"
      })
    ]));

    /* --- pill ----------------------------------------------------- */
    var pill = h("button", {
      class: "rcac-ow-pill",
      type: "button",
      "aria-expanded": "false",
      "aria-label": "RCAC system status: " + label
    }, [
      h("span", { class: "rcac-ow-dot", "aria-hidden": "true" }),
      h("span", { class: "rcac-ow-label", text: label })
    ]);

    root.appendChild(panel);
    root.appendChild(pill);
    document.body.appendChild(root);

    function setOpen(open) {
      if (open) panel.removeAttribute("hidden");
      else panel.setAttribute("hidden", "");
      pill.setAttribute("aria-expanded", String(open));
      try { sessionStorage.setItem(OPEN_KEY, open ? "1" : "0"); } catch (e) {}
    }

    pill.addEventListener("click", function () {
      setOpen(panel.hasAttribute("hidden"));
    });
    panel.querySelector(".rcac-ow-close").addEventListener("click", function () {
      setOpen(false);
    });
    document.addEventListener("keydown", function (ev) {
      if (ev.key === "Escape") setOpen(false);
    });

    // Re-open if it was open before an instant-navigation reload,
    // or auto-open once per session when there is an active outage.
    var wasOpen = null;
    try { wasOpen = sessionStorage.getItem(OPEN_KEY); } catch (e) {}
    if (wasOpen === "1" || (level === "error" && wasOpen === null)) setOpen(true);
  }

  /* ------------------------------------------------------------------ *
   * Bootstrapping (works with and without navigation.instant)
   * ------------------------------------------------------------------ */
  function shouldShowOnThisPage() {
    if (!CONFIG.homepageOnly) return true;
    return !!document.getElementById("outage-widget-anchor");
  }

  function init() {
    if (!shouldShowOnThisPage()) { removeWidget(); return; }
    if (document.getElementById("rcac-outage-widget")) return;

    fetchStatus()
      .then(render)
      .catch(function (err) {
        // Fail quietly: a docs site must never break because the
        // status API is unreachable.
        console.warn("[outage-widget]", err);
        removeWidget();
      });

    refreshTimer = setInterval(function () {
      if (document.hidden) return;
      try { sessionStorage.removeItem(CACHE_KEY); } catch (e) {}
      fetchStatus().then(render).catch(function () {});
    }, CONFIG.refreshMinutes * 60 * 1000);
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
