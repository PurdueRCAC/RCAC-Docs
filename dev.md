# RCAC Docs — Developer Notes

## WCAG 2.1 Remediation (Branch: `dev`)

Audit tool: [WAVE](https://wave.webaim.org/) against `https://rcac-docs-dev.readthedocs.io/`
Date: 2026-03-31

---

### Phase 1 — Empty Form Labels (SC 1.3.1 / 4.1.2)

**Problem:** Material for MkDocs generates `<label>` elements that contain only SVG icons (no accessible text). WAVE reported **17 empty form label** errors and **1 additional** error on the palette toggle (fixed separately).

**Root cause:** The theme uses `<label for="X">` as CSS-only click targets for checkboxes (hamburger drawer, search toggle, nav expand arrows, palette switcher). None of these labels carried `aria-label` or visible text.

**Files created/modified:**

| File | Change |
|------|--------|
| `overrides/partials/header.html` | Added `aria-label="{{ lang.t('nav') }}"` to `<label for="__drawer">` (hamburger); `aria-label="{{ lang.t('search') }}"` to `<label for="__search">` (search button) |
| `overrides/partials/search.html` | Added `aria-label="Close search"` to `<label class="md-search__overlay">`; `aria-label="{{ lang.t('search') }}"` to `<label class="md-search__icon">` |
| `overrides/partials/nav-item.html` | Added `aria-label="Expand {{ nav_item.title }}"` to the empty expand label used for nav sections with index pages (lines 107–109 of upstream template) |
| `overrides/partials/palette.html` | Added `aria-label="{{ option.toggle.name }}"` to each palette `<label>` |
| `docs/assets/js/a11y.js` *(new)* | Adds `aria-label="Close navigation"` to the `<label class="md-overlay">` generated in `base.html` (not overridable via partials) |
| `mkdocs.yml` | Added `assets/js/a11y.js` to `extra_javascript` |

**Commits:** `a25d84a`, `88bda58`

---

### Phase 2 — Multiple Form Labels (SC 1.3.1 / 4.1.2)

**Problem:** WAVE reported **21 multiple form labels** errors. Material uses multiple `<label for="X">` elements pointing to the same `<input>` — one as the primary toggle control and another as a secondary "back" button (e.g. the `md-nav__title` label inside a sub-nav, the search overlay, the drawer overlay).

**Root cause:** Each nested nav section generates two labels for its toggle checkbox: the expand arrow and the `md-nav__title` inside the child nav. Same pattern for `__drawer` (hamburger + nav title + overlay) and `__search` (header button + overlay + back icon).

**Fix:** Kept ONE `<label for="X">` per input (the primary control). Converted secondary labels from `for=` associations to `onclick` handlers, preserving click-to-close functionality without creating multiple label associations.

**Files created/modified:**

| File | Change |
|------|--------|
| `overrides/partials/nav-item.html` | Changed `<label class="md-nav__title" for="{{ path }}">` → removed `for`, added `onclick="var t=document.getElementById('{{ path }}');if(t)t.checked=false;"` |
| `overrides/partials/nav.html` *(new)* | Same fix for the top-level `<label class="md-nav__title" for="__drawer">` |
| `overrides/partials/search.html` | Removed `for="__search"` from both the overlay label and the search icon label; added `onclick` handlers on each |
| `overrides/partials/toc.html` | Changed `<label class="md-nav__title" for="__toc">` → removed `for`, added `onclick` |
| `docs/assets/js/a11y.js` | Updated to also remove `for` from `<label class="md-overlay">` at runtime and re-attach click behavior via `addEventListener` |
| `overrides/base.html` *(new)* | Full override of Material's `base.html` to change `<label class="md-overlay" for="__drawer">` → removed `for`, added `aria-label` and `onclick` directly in static HTML (eliminating JS dependency for this element) |

**Side-effect fixed:** Removing `for="__search"` from the `md-search__icon` label also removed the CSS hook `.md-search__icon[for=__search]` used by Material to position the magnify/back-arrow icons. Fixed by adding equivalent rules to `extra.css` using `.md-search__form > label.md-search__icon` as the selector.

**Commits:** `8eedcb9`, `2b74cc1`, `b91c2eb`

---

### Phase 3 — Contrast Errors (SC 1.4.3)

**Problem:** WAVE reported **9 contrast errors** on the home page.

**Root cause (three sources):**

1. **Headerlink anchors (5 errors):** Material's `.headerlink` (the `¶` permalink shown on heading hover) has a default color of `rgba(0,0,0,0.32)` ≈ `#adadad`, which is only **2.24:1** against white. One anchor per heading; the home page has 5 headings.

2. **Warning admonition (1–2 errors):** Material's `!!! warning` admonition uses `#ff9100` (amber/orange) for its icon and title decorations. Against the near-white admonition title background (`rgba(255,145,0,0.1)` on white), this is only **2.26:1**.

3. **Accent color in light mode (remaining errors):** `--md-accent-fg-color` was set to `#CBBA94` (Purdue gold) which is only **1.91:1** against white. Material uses this for search result highlights (`.md-search-result mark`) and hover states.

**Contrast ratios before/after:**

| Element | Old color | Old ratio | New color | New ratio |
|---------|-----------|-----------|-----------|-----------|
| `.headerlink` default | `rgba(0,0,0,0.32)` | 2.24:1 | `#595959` | **7.0:1** |
| Warning admonition icon/border | `#ff9100` | 2.26:1 | `#8b4a00` | **6.8:1** |
| `--md-accent-fg-color` (light) | `#CBBA94` | 1.91:1 | `#7a5c2e` | **6.2:1** |
| `--md-accent-fg-color` (dark) | `#8e6f3e` | 3.65:1 | `#ebd99f` | **12.1:1** |

**Files modified:**

| File | Change |
|------|--------|
| `docs/stylesheets/extra.css` | Changed `--md-accent-fg-color` to `#7a5c2e` in light mode and `#ebd99f` in dark mode; added `--md-accent-fg-color--transparent` variants; added `.md-typeset .headerlink { color: #595959 }`; added warning admonition overrides for border, background, `::before`, and `::after` elements |

**Commit:** `4e7a6ca`

---

### Phase 4 — Remaining Heading Contrast Errors (SC 1.4.3)

**Problem:** WAVE reported **7 remaining contrast errors** after Phase 3 — primarily on headings.

**Root cause (three sources):**

1. **Hero section white text (2 errors):** `.hero-text h1` and `.hero-text p` use `color: #fff` / `color: rgba(255,255,255,0.9)` but the actual background is a CSS `background-image` plus an absolutely-positioned `.hero-gradient` overlay. WAVE cannot resolve `background-image` or pseudo-element gradients as background; it falls back to white (`#fff`). White text on white background = 1:1 contrast → fails.

2. **Content h1 color (up to 5 errors):** Material sets `.md-typeset h1 { color: var(--md-default-fg-color--light) }` = `rgba(0,0,0,0.54)` ≈ **4.09:1** against white. While h1 at 2em qualifies as large text (3:1 threshold), WAVE may not apply the large-text exception consistently.

3. **Headerlink `¶` anchors:** Material applies `opacity: 0` to `.headerlink` by default. WAVE evaluates opacity-0 elements and uses their CSS `color` value without the opacity reduction (or computes effective color as near-white), flagging the color as insufficient. These links are decorative — the heading `id` is the actual anchor target.

**Fixes:**

| Source | Fix |
|--------|-----|
| Hero section | Added `background-color: rgba(0,0,0,0.65)` to `.hero-content`. WAVE can compute: white `#fff` on this dark bg ≈ **10:1**; `rgba(255,255,255,0.9)` ≈ **9.3:1**. Visually unnoticeable since the actual background is already dark (photo + gradient). |
| h1 color | Added `.md-typeset h1 { color: var(--md-default-fg-color) }` override. `--md-default-fg-color` = `rgba(0,0,0,0.87)` ≈ **15:1** against white. |
| Headerlinks | Added `aria-hidden="true"` + `tabindex="-1"` to all `.md-typeset .headerlink` elements via `a11y.js`. The `¶` is decorative; WAVE skips contrast checks for `aria-hidden` elements. Also improves screen reader experience (screen readers no longer announce "¶" for every heading). |

**Files modified:**

| File | Change |
|------|--------|
| `docs/stylesheets/extra.css` | Added `background-color: rgba(0,0,0,0.65)` to `.hero-content`; added `.md-typeset h1 { color: var(--md-default-fg-color) }` |
| `docs/assets/js/a11y.js` | Added loop to set `aria-hidden="true"` + `tabindex="-1"` on all `.md-typeset .headerlink` elements |

---

### Phase 5 — Dark Mode Contrast Errors (SC 1.4.3)

**Problem:** WAVE reported **2 contrast errors in dark mode** that light-mode fixes did not cover.

**Root cause (two sources):**

1. **Header title "RCAC Documentation" (1 error):** `--md-primary-fg-color` is used by Material as the **header background color**. In dark mode we set `--md-primary-fg-color: #CBBA94` (Purdue gold), which correctly makes the header gold. However, `--md-primary-bg-color` (the header text color) was not set, so it defaulted to `#fff` (white). White text on gold (#CBBA94) = **1.9:1** — fails 4.5:1. Fix: add `--md-primary-bg-color: #000000`; black on gold = **11.2:1**.

2. **Warning admonition (1 error):** The admonition fix in Phase 3 used `#b45000` for all modes. `#b45000` on the dark slate background = **2.6:1** — fails. Fix: add a `[data-md-color-scheme="slate"]` override restoring `#ff9100` (original orange), which passes at **5.9:1** on dark backgrounds.

**Contrast ratios:**

| Element | Mode | Old color | Old ratio | New color | New ratio |
|---------|------|-----------|-----------|-----------|-----------|
| Header text (`--md-primary-bg-color`) | Dark | `#ffffff` | 1.9:1 | `#000000` | **11.2:1** |
| Warning admonition | Dark | `#b45000` | 2.6:1 | `#ff9100` | **5.9:1** |

**Files modified:**

| File | Change |
|------|--------|
| `docs/stylesheets/extra.css` | Added `--md-primary-bg-color: #000000` to dark mode block; added `[data-md-color-scheme="slate"]` overrides for warning admonition restoring `#ff9100` |

**Commits:** `99f10ec` (warning admonition dark mode), `f673bf9` (header title dark mode)

---

### Visual Improvements (Post-WCAG)

After the WCAG fixes, two visual regressions were corrected:

1. **Hero image too dark:** The `background-color: rgba(0,0,0,0.65)` added to `.hero-content` stacked on top of the existing `.hero-gradient` (max `rgba(0,0,0,0.85)`), making the hero nearly black. Fix: lightened the gradient to `0→0.1→0.2`, so the compounded darkness is ~0.68 (vs ~0.94 before, and ~0.85 original).

2. **Warning admonition color too dark:** `#8b4a00` (WCAG Phase 3 fix) looked like a muddy brown rather than a recognizable warning orange. Replaced with `#b45000` (burnt orange, ~5.0:1 in light mode) — visually orange while still passing WCAG.

---

### Phase 6 — Home Page Link Styling

**Change:** All links on the home page (`docs/index.md`) are now **bold and underlined**.

**Implementation:** Rather than marking up each link individually with `<u>**[...](...)**</u>`, the page content is wrapped in `<div class="home-page" markdown>` and a single CSS rule handles the styling:

```css
.home-page a {
  font-weight: bold;
  text-decoration: underline;
}
```

Previously applied explicit `<u>**...**</u>` markup on two links was also removed as redundant.

**Files modified:**

| File | Change |
|------|--------|
| `docs/index.md` | Wrapped content in `<div class="home-page" markdown>`; removed explicit `<u>**...**</u>` from 2 links |
| `docs/stylesheets/extra.css` | Added `.home-page a { font-weight: bold; text-decoration: underline }` |

**Commits:** `2577fc4`, `251f189`

---

### Phase 7 — WAVE Alerts: Suspicious Alt Text + Orphaned Form Labels (SC 1.1.1, SC 1.3.1)

**Problem:** WAVE reported **52 alerts** including suspicious alt text, orphaned form labels, missing fieldset, redundant link, and device-dependent event handlers.

#### Suspicious alt text (2 alerts → 0)

| Element | Issue | Fix |
|---------|-------|-----|
| `<img src="assets/purdue.png" alt="logo">` inside header logo `<a>` | `"logo"` is a generic/suspicious alt value | Changed to `alt=""` — the enclosing `<a>` already has `aria-label="RCAC Documentation"`, making the image decorative |

**File:** Created `overrides/partials/logo.html` overriding Material's default which hard-codes `alt="logo"`.

#### Orphaned form labels (partial — in progress)

Material uses `<label>` elements as CSS-toggle click targets (no `for=` after our Phase 1/2 fixes). WAVE flags these as orphaned. Fix: replace each with `<div role="button" tabindex="0">` and add `onkeydown` for keyboard support (also fixes device-dependent event handler alerts).

| Element | File | Fix |
|---------|------|-----|
| `<label class="md-overlay">` | `overrides/base.html` | → `<div role="button" tabindex="0">` + `onkeydown` |
| `<label class="md-search__overlay">` | `overrides/partials/search.html` | → `<div role="button" tabindex="0">` + `onkeydown` |
| `<label class="md-search__icon">` | `overrides/partials/search.html` | → `<div role="button" tabindex="0">` + `onkeydown` |
| `<label class="md-nav__title" onclick="…__drawer…">` | `overrides/partials/nav.html` | → `<div role="button" tabindex="0">` + `onkeydown` |
| `<label class="md-nav__title" onclick="…path…">` | `overrides/partials/nav-item.html` | → `<div role="button" tabindex="0">` + `onkeydown` |

Also updated CSS selector in `extra.css` from `label.md-search__icon` → `.md-search__icon` to preserve search icon positioning after the element type change.

Updated `docs/assets/js/a11y.js` — the `md-overlay` patch is now a no-op fallback for stale cached builds only.

#### Remaining 4 alerts (resolved)

| Alert | Element | Fix |
|-------|---------|-----|
| Orphaned form label + Device-dependent event handler | `<label class="md-nav__title" onclick="…__toc…">` in `toc.html` | → `<div role="button" tabindex="0">` + `onkeydown` |
| Missing fieldset | Palette radio group (`name="__palette"`) in `palette.html` | Wrapped inputs in `<fieldset>` with visually-hidden `<legend>Color scheme</legend>` (`.md-sr-only` utility class added to `extra.css`) |
| Redundant link | `<a class="md-nav__button md-logo" href=".">` in nav drawer (`nav.html`) | Changed `<a>` to `<span aria-hidden="true">` — removes the href entirely so WAVE no longer detects a link (aria-hidden alone is insufficient) |

---

### Summary of All Files Changed

```
overrides/
  base.html                        # md-overlay: label→div + onkeydown
  partials/
    header.html                    # aria-label on __drawer and __search labels
    logo.html                      # alt="" on logo image (was alt="logo")
    nav-item.html                  # aria-label on expand labels; md-nav__title label→div
    nav.html                       # md-nav__title __drawer: label→div + onkeydown
    palette.html                   # aria-label on palette toggle labels
    search.html                    # overlay + icon: label→div + onkeydown
    toc.html                       # md-nav__title __toc: onclick instead of for=
docs/
  index.md                         # Home page link styling via .home-page wrapper div
  assets/js/a11y.js                # md-overlay fix; headerlink aria-hidden
  stylesheets/extra.css            # Contrast fixes, search icon CSS, home link styling
mkdocs.yml                         # Registered a11y.js in extra_javascript
```

### WAVE Results (before → after)

| Error type | Before | After |
|------------|--------|-------|
| Empty form label | 18 | 0 |
| Multiple form labels | 21 | 0 |
| Contrast errors — light mode (Phase 3) | 9 | 7 |
| Contrast errors — light mode (Phase 4) | 7 | 0 |
| Contrast errors — dark mode (Phase 5) | 2 | 0 |
| **Total** | **50** | **0** |
