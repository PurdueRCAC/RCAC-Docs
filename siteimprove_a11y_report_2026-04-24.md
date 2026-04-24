# Siteimprove Accessibility Report — RCAC Docs Prod
**Site:** https://docs.rcac.purdue.edu/  
**Date:** 2026-04-24  
**Pages crawled:** 402

---

## Current Scores

| Level | Score | Max Possible Gain |
|---|---:|---:|
| A11y Total | 81.2 | +18.8 |
| WCAG A | 87.7 | +12.3 |
| WCAG AA | 74.6 | +25.4 |
| WCAG AAA | 62.5 | +37.5 |
| ARIA | 69.8 | +30.2 |
| Siteimprove Rules (SI) | 82.0 | +18.0 |

> **Estimation note:** Level A gains are reliable (formula checks within 0.3%). AA, AAA, and ARIA diverge more — Siteimprove likely applies difficulty weighting — so treat those as directional, not precise.

---

## Confirmed Issues & Score Gains

### Level A — Current: 87.7 | Max gain: +12.3 → 100

| Issue | Rule | Occurrences | Pages | Est. Gain | Effort |
|---|---|---:|---:|---:|---|
| ~~Link missing text alternative~~ ✅ | R11 | 6 | 6 | +4.1 | Easy |
| ~~Table cell missing context (no `<th>` assigned)~~ ✅ | R77 | 12 | 3 | +4.1 | Easy |
| ~~No data cells assigned to table header~~ ✅ | R46 | 2 | 1 | +4.1 | Easy |
| **Fix all 3** | | | | **+12.3** | |

**Affected pages (R11 — link alt text):**
- `docs/datasets/geoai/burn_intensity.md`
- `docs/datasets/geoai/gravity-wave-parameterization.md`
- `docs/datasets/geoai/hls_merra2_gppFlux.md`
- `docs/datasets/geoai/hurricane.md`
- `docs/datasets/geoai/Landslide4sense.md`
- `docs/datasets/geospatial/NALCMS.md`

**Root cause (R11):** DOI table row uses icon-only link with no label text:
```markdown
| **DOI** | [ :octicons-link-external-16:](https://doi.org/) |
```
**Fix:** Add visible text before the icon:
```markdown
| **DOI** | [DOI Link :octicons-link-external-16:](https://doi.org/) |
```

---

### Level AA — Current: 74.6 | Max gain: +25.4 → 100

| Issue | Rule | Occurrences | Pages | Est. Gain | Effort |
|---|---|---:|---:|---:|---|
| Color contrast does not meet minimum (4.5:1) | R69 | 231 | 67 | +12.7 | Medium |
| Interactive element too small or insufficient spacing | R113 | 685 | 65 | +12.7 | Hard |
| **Fix all 2** | | | | **+25.4** | |

---

### ARIA — Current: 69.8 | Max gain: +30.2 → 100

| Issue | Rule | Occurrences | Pages | Est. Gain | Effort |
|---|---|---:|---:|---:|---|
| ARIA attribute unsupported or prohibited | R18 | 1,366 | 394 | +30.2 | Hard |
| **Fix all 1** | | | | **+30.2** | |

---

### Siteimprove Rules (SI) — Current: 82.0 | Max gain: +18.0 → 100

| Issue | Rule | Occurrences | Pages | Est. Gain | Effort |
|---|---|---:|---:|---:|---|
| Improper use of `<pre>` element | R79 | 780 | 325 | +9.0 | Medium |
| Headings not structured (levels skipped) | R53 | 20 | 17 | +9.0 | Easy |
| **Fix all 2** | | | | **+18.0** | |

---

### Level AAA — Current: 62.5 | Max gain: +37.5 → 100
*(Not required for WCAG compliance — fix after A/AA are clean)*

| Issue | Rule | Occurrences | Pages | Est. Gain | Effort |
|---|---|---:|---:|---:|---|
| Color contrast does not meet enhanced requirement (7:1) | R66 | 15,293 | 402 | +12.5 | Medium |
| Interactive element does not meet enhanced size (44×44px) | R111 | 11,642 | 402 | +12.5 | Hard |
| Line height below minimum (< 1.5×) | R73 | 2 | 1 | +12.5 | Easy |
| **Fix all 3** | | | | **+37.5** | |

---

## Potential Issues (Unconfirmed — Need Manual Review)

These do not currently affect the score but will if confirmed.

| Issue | Level | Rule | Occurrences | Pages |
|---|---|---|---:|---:|
| Keyboard focus indicator not visible | AA | R65 | 2,084 | 402 |
| Color contrast undetectable (needs manual check) | AA | R69 | 410 | 402 |
| Skip-to-main-content link missing | SI | R87 | 402 | 402 |
| Identical links in same context (same destination?) | A | R81 | 257 | 255 |
| Identical links (different destinations?) | AAA | R41 | 1,337 | 401 |
| Landmarks with same name — same purpose? | ARIA | R55 | 86 | 86 |
| Video without audio — accessible alternative? | A | R35 | 2 | 1 |
| Video audio description missing | AA | R37 | 2 | 1 |
| Video captions missing | A | R27 | 2 | 1 |
| Video — alternative to visual content? | A | R38 | 2 | 1 |

---

## Recommended Fix Order

Sorted by score gain per effort — easy wins first, compliance-critical before optional.

| Priority | Fix | Level | Est. Level Gain | Effort |
|---|---|---|---:|---|
| 1 | ~~Link missing text alt (6 files, 1-liner each)~~ ✅ | A | +4.1 | Easy |
| 2 | ~~Table cell missing context (3 pages)~~ ✅ | A | +4.1 | Easy |
| 3 | ~~No data cells for table header (1 page)~~ ✅ | A | +4.1 | Easy |
| 4 | Headings not structured (17 pages) | SI | +9.0 | Easy |
| 5 | Line height < 1.5× (1 page) | AAA | +12.5 | Easy |
| 6 | Color contrast AA — 4.5:1 (67 pages) | AA | +12.7 | Medium |
| 7 | Improper `<pre>` element (325 pages) | SI | +9.0 | Medium |
| 8 | Color contrast AAA — 7:1 (402 pages) | AAA | +12.5 | Medium |
| 9 | Interactive element size AA (65 pages) | AA | +12.7 | Hard |
| 10 | ARIA attribute unsupported (394 pages) | ARIA | +30.2 | Hard |
| 11 | Interactive element size AAA (402 pages) | AAA | +12.5 | Hard |

**Fixing priorities 1–3** clears all WCAG Level A violations (compliance floor).  
**Fixing priorities 1–5** sweeps all "Easy" issues across A, SI, and AAA.  
**Fixing priorities 1–7** moves the A11y total from **81.2 → ~88–90**.  
**Fixing all 11** pushes each sub-score toward 100 and the A11y total toward **~100**.
