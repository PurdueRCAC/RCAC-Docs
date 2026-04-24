# Siteimprove Report — RCAC Docs Prod
**Site:** https://docs.rcac.purdue.edu/  
**Date:** 2026-04-24  
**Pages crawled:** 402

---

## Overall DCI Score: 68.7 / 100

| Category | Score |
|---|---:|
| Accessibility (A11y) | 81.2 |
| SEO | 80.0 |
| Quality Assurance | 44.9 ⚠️ |

> QA is dragged down by a UX sub-score of 27.1, almost entirely due to 306 "Domain suspended" broken links against the production domain. Fixing the domain crawler issue would recover this score significantly.

---

## Accessibility (A11y): 81.2 / 100

| WCAG Level | Sub-score |
|---|---:|
| A | 87.7 |
| AA | 74.6 |
| AAA | 62.5 |
| ARIA | 69.8 |
| Siteimprove rules | 82.0 |

### Confirmed Issues

| WCAG Level | Issue | Occurrences | Pages | Priority |
|---|---|---:|---:|---|
| **A** | Link missing a text alternative | 6 | 6 | High |
| **A** | Table cell missing context (no `<th>` assigned) | 12 | 3 | High |
| **A** | No data cells assigned to table header | 2 | 1 | High |
| **AA** | Color contrast does not meet minimum (4.5:1) | 231 | 67 | High |
| **AA** | Interactive element <24×24px or insufficient spacing | 685 | 65 | High |
| ARIA | ARIA attribute unsupported or prohibited | 1,366 | 394 | Medium |
| SI | Improper use of `<pre>` element | 780 | 325 | Medium |
| SI | Headings not structured (levels skipped) | 20 | 17 | Medium |
| AAA | Color contrast does not meet enhanced requirement | 15,293 | 402 | Low |
| AAA | Interactive element <44×44px | 11,642 | 402 | Low |
| AAA | Line height below minimum (< 1.5×) | 2 | 1 | Low |

### Potential Issues (unconfirmed)

| WCAG Level | Count |
|---|---:|
| A | 4 |
| AA | 3 |
| AAA | 2 |
| ARIA | 1 |

---

## SEO: 80.0 / 100

| Sub-category | Score |
|---|---:|
| Content | 81.2 |
| Technical | 78.2 |
| Mobile | 72.5 |
| UX | 99.8 |

### Issues

| Severity | Issue | Pages Affected |
|---|---|---:|
| Error | Duplicate page titles | 18 |
| Warning | Duplicate meta descriptions | 434 (all pages) |
| Warning | Duplicate H1 headings | 10 |
| Review | Pages not in XML sitemap | 32 |

---

## Quality Assurance: 44.9 / 100

| Sub-category | Score |
|---|---:|
| Content | 92.8 |
| Freshness | 99.6 |
| Security | 70.0 |
| UX | 27.1 ⚠️ |

### Broken Links: 345 total

**306 internal** — all flagged "Domain suspended" (production domain unreachable from Siteimprove crawler). These will clear once the domain issue is resolved.

Real internal issues:

| URL | Pages | Issue |
|---|---:|---|
| `/assets/pdfs/lifesciences/TODO` | 5 | Placeholder — link never set |
| `/blog/2026/01/14/logging-in-to-the-community-clusters-via-thinlinc/` | 2 | 404 — blog post missing |

**39 external** broken links:

| Error Type | Count | URLs |
|---|---:|---|
| 403 Forbidden (bot protection) | 14 | `lmod.readthedocs.io`, `mpi4py.readthedocs.io`, `gdal.org`, `gurobi.com`, `mikado.readthedocs.io` (×2), `hifiasm.readthedocs.io` (×2), `xalt.readthedocs.io`, `hyper-shell.readthedocs.io`, `resource-monitor.readthedocs.io`, `rcac-hpc-exchange.readthedocs.io`, `ab-initio.mit.edu/wiki/...meep`, `cola.gmu.edu/grads/` |
| 404 Not Found | 8 | `rcac-bioinformatics.github.io/guide/`, `lvisdataset.org/dataset`, `chelsa-climate.org/bioclim/`, `rcac.purdue.edu/files/hpss/htar_man.html`, `rcac.purdue.edu/knowledge/gautschi/storage/depot/smb`, `rcac.purdue.edu/knowledge/gautschi/run/examples/apps/r/rprofile`, `dataverse.harvard.edu/...DVN/GIVQ75`, `plabipd.de/helixer_main.html` |
| 502 Bad Gateway | 4 | `gaussian.com` (×3 — g09citation, g16citation, gaussview6), `gaussian.com` main |
| SSL Error | 3 | `purdue.edu/apps/account/r4p`, `it.purdue.edu/services/vpn.php`, `purdue.edu/vpn/` |
| Connection Timeout | 3 | `ondemand.anvil.rcac.purdue.edu` (×2), `xdmod.rcac.purdue.edu` |
| Other | 2 | `frdr-dfdr.ca` (×2 — dataset links) |
| Unreachable | 1 | `giss.nasa.gov/tools/panoply/` |

### Spelling: 9 confirmed misspellings

| Misspelled | Correction |
|---|---|
| operaton | operation |
| labelled | labeled |
| reccomend | recommend |
| documention | documentation |
| relevent | relevant |
| continously | continuously |
| intoduction | introduction |
| wil | will |
| avaiable | available |

> 1,166 potential misspellings flagged for review (technical terms, proper nouns likely included).

---

## Recommended Fix Order

| Priority | Area | Action | Impact |
|---|---|---|---|
| 1 | QA | Investigate why `docs.rcac.purdue.edu` shows "Domain suspended" to Siteimprove | Clears 306 false-positive broken links, recovers QA score |
| 2 | A11y A | Fix 6 links missing text alternatives | WCAG A compliance |
| 3 | A11y A | Fix 14 table cells missing header context | WCAG A compliance |
| 4 | A11y AA | Fix 231 color contrast failures (4.5:1 min) | WCAG AA compliance |
| 5 | A11y AA | Fix 685 interactive element size/spacing issues | WCAG AA compliance |
| 6 | Spelling | Fix 9 confirmed misspellings in content | Content quality |
| 7 | QA Links | Replace/remove 8 external 404 links | Real broken links |
| 8 | QA Links | Fix placeholder `/assets/pdfs/lifesciences/TODO` (5 pages) | Real broken link |
| 9 | SEO | Deduplicate 18 page titles | SEO score |
| 10 | SEO | Add unique meta descriptions (currently all 434 pages share one) | SEO score |
