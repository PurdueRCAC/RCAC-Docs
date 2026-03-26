# RCAC Documentation Website

## Project Overview
This is the **Zensical**-based documentation website for the **Rosen Center for Advanced Computing (RCAC)** at Purdue University. It provides comprehensive user guides, tutorials, reference material, software catalogs, datasets, blog articles, and workshop materials for RCAC's HPC systems (Anvil and Gautschi).

**Primary URL**: https://rcac-docs.s3-hosted.rcac.purdue.edu
**Demo/Staging URL**: https://rcac-docs-demo.readthedocs.io
**Source Repository**: https://github.com/PurdueRCAC/RCAC-Docs

> **Migration note**: This project was migrated from MkDocs + Material for MkDocs to Zensical (v0.0.29) in March 2026. The `main` branch still contains the original MkDocs setup; the `zensical` branch holds the new framework.

### Reference Sites
The following HPC documentation sites use a similar framework and serve as design/content references:
- https://docs.tacc.utexas.edu/
- https://docs.alcf.anl.gov/
- https://docs.ncsa.illinois.edu/en/latest/
- https://docs.jetstream-cloud.org/
- https://docs.hpc.ucdavis.edu/

## Repository Structure

```
RCAC-Docs/
├── .github/workflows/        # GitHub Actions automation
├── docs/                     # Main documentation content
│   ├── assets/              # Images, CSS, JS, data files
│   │   ├── fonts/           # Purdue UnitedSans font files
│   │   ├── images/          # Hero banner and other images
│   │   └── js/              # Custom JavaScript
│   │       ├── homepage.js          # TOC hide + full-width on homepage
│   │       ├── tablefilter.js       # App catalog filtering library
│   │       ├── init-tablefilter.js  # App catalog filter initialization
│   │       ├── breadcrumbs.js       # Breadcrumb navigation
│   │       └── external-links.js
│   ├── blog/                # Blog posts
│   ├── datasets/            # Dataset documentation
│   ├── software/            # Software catalog pages
│   ├── stylesheets/
│   │   └── extra.css        # Purdue/RCAC branding and layout
│   ├── userguides/          # User guides (Anvil, Gautschi)
│   ├── workshops/           # Workshop materials (HPC Exchange)
│   ├── contact.md           # Contact page
│   ├── faq.md               # FAQ page
│   └── index.md             # Homepage (includes hero banner HTML)
├── modulefiles/             # HPC module files (software installations)
├── overrides/               # Zensical theme overrides
│   └── main.html            # Injects breadcrumb container
├── tools/                   # Automation scripts for software catalog
├── hooks/                   # Legacy MkDocs hooks (reference only)
├── main.py                  # Legacy MkDocs macros (reference only)
├── zensical.toml            # Zensical configuration (replaces mkdocs.yml)
├── requirements.txt         # Python dependencies
└── .readthedocs.yaml        # Read the Docs configuration
```

## Technology Stack

### Core Technologies
- **Zensical**: Static site generator (v0.0.29) — Rust core + Python
- **Python 3.x**: Runtime environment
- **GitHub Actions**: CI/CD automation
- **conda environment**: `zensical` (at `/home/jin456/.conda/envs/zensical/`)

### Key Dependencies (requirements.txt)
- `zensical==0.0.29`: Static site generator
- `Markdown==3.10.2`: Markdown processing
- `Pygments==2.19.2`: Syntax highlighting
- `pymdown-extensions==10.21`: Enhanced markdown (admonitions, code blocks, emoji, etc.)
- `PyYAML==6.0.3`: YAML parsing
- `requests==2.33.0`: HTTP library

### Markdown Extensions (via pymdown-extensions)
- `pymdownx.highlight`: Code syntax highlighting with Pygments
- `pymdownx.superfences`: Fenced code blocks
- `pymdownx.tabbed`: Tabbed content
- `pymdownx.details`: Collapsible sections
- `pymdownx.emoji`: Emoji support (Material icons)
- `admonition`: Callout boxes (note, warning, tip, etc.)
- `tables`, `attr_list`, `toc`, `footnotes`

### Theme
- **Variant**: `classic` (Material for MkDocs-compatible HTML structure)
- **custom_dir**: `overrides/`
- **Colors**: Purdue gold (`#CBBA94`) accent, black primary
- **Fonts**: Roboto (text), Consolas (code), UnitedSans (header/nav)
- **Light/dark mode**: System-preference-aware palette toggle

## Content Organization

### Major Sections
1. **HPC User Guides**: Comprehensive guides for Anvil and Gautschi clusters
2. **Blog**: News and updates
3. **Software Catalog**: Auto-generated catalog of available software
4. **Datasets**: Available datasets (AI, hydrological, meteorological, geospatial, etc.)
5. **Workshops**: Training materials (HPC Exchange series)

### Frontmatter Convention
Zensical v0.0.29 has a known bug: YAML list, dict, and bool values in frontmatter cause a Rust `TypeError` and prevent page rendering. All `.md` files use one of these safe formats:

- **Non-empty frontmatter** (commented out to disable parsing):
  ```
  <!-- ---
  # key: value
  --- -->
  ```
- **Empty frontmatter** (commented out):
  ```
  <!-- ---
  --- -->
  ```

Do **not** use bare `---` YAML frontmatter in any `.md` file.

### Software Catalog System
The software catalog is **automatically generated** from HPC module files:

**Process Flow**:
1. `modulefiles/` → Module files for installed software
2. `tools/update_apps_inventory.sh` → Extracts app names, versions, clusters
3. `tools/generate_apps_topics.py` → Categorizes apps by topic
4. `tools/gen_apps_descriptions.py` → Fetches descriptions from Spack/Wikipedia/PyPI
5. `tools/generate_md.sh` → Creates individual markdown files
6. `tools/update_apps_catalog.sh` → Updates catalog index page

**Topics**: MPI, Compilers, Chemistry, Fluid Dynamics, Geoscience, Math/Stats, Engineering, Utilities, Workflow, etc.

## Automation & Workflows

### GitHub Actions

#### 1. **rebuild_on_module_tools_change.yml**
- **Triggers**: Push to `main` branch when `modulefiles/**` or `tools/**` change
- **Purpose**: Automatically regenerate software catalog
- **Process**:
  1. Runs `make` in `tools/` directory
  2. Commits updated catalog files to repository
  3. Uses GitHub App authentication (`purduercac-docs-bot`)
- **Updates**: `docs/software/apps_md/`, `app_catalog.md`, `index.md`

#### 2. **update_breadcrumbs.yml**
- **Triggers**: Push to `main` branch when `zensical.toml` changes
- **Purpose**: Regenerate navigation breadcrumbs
- **Process**:
  1. Runs `tools/generate_breadcrumbs.py`
  2. Updates `docs/assets/data/breadcrumbs.json`
  3. Commits changes automatically

### GitHub App Bot
- **Name**: `purduercac-docs-bot`
- **Purpose**: Automated commits to avoid triggering recursive workflows
- **Configuration**: Uses app ID and private key from repository secrets

### Read the Docs Integration
- Configured via `.readthedocs.yaml`
- Automatically builds and deploys on push to relevant branch
- Uses Ubuntu 24.04 with Python 3

## Development Workflow

### Local Development Setup
```bash
# Load conda and activate environment
module load conda
conda activate zensical

# Build site
zensical build

# Serve locally (live reload)
zensical serve
```

### Using conda run (without activating)
```bash
module load conda
conda run -n zensical zensical build
conda run -n zensical zensical serve
```

### Making Changes

#### Content Changes
1. Edit markdown files in `docs/`
2. Do NOT use bare YAML frontmatter — use the `<!-- ---...--- -->` comment format
3. Test locally with `zensical serve`
4. Commit and push

#### Software Catalog Updates
1. Add/modify module files in `modulefiles/`
2. Push to `main` branch
3. GitHub Action automatically runs `make` to regenerate catalog
4. Bot commits updated catalog files

#### Navigation Changes
1. Edit `nav` section in `zensical.toml` (TOML array-of-dicts format)
2. Regenerate breadcrumbs if needed: `python3 tools/generate_breadcrumbs.py`

### Manual Catalog Generation
```bash
cd tools
make  # Runs all steps in correct order

# Or run individually:
./update_apps_inventory.sh -v
./generate_apps_topics.py
./update_apps_descriptions_from_inventory.sh
./generate_md.sh
./update_apps_catalog.sh
```

## Special Features

### Homepage Hero Banner
The hero banner lives directly in `docs/index.md` as raw HTML (not in a template), because Zensical's MiniJinja does not expose `page.is_homepage`. The `homepage.js` script hides the TOC sidebar and expands content width at runtime by checking `window.location.pathname`.

### Breadcrumb Navigation
Injected via `overrides/main.html` (a `<div class="md-breadcrumb">` placeholder) and populated client-side by `docs/assets/js/breadcrumbs.js` using `docs/assets/data/breadcrumbs.json`.

### App Catalog Table Filtering
`tablefilter.js` + `init-tablefilter.js` provide live filtering on the software catalog table (`#appTable`). Styled to respect light/dark mode via CSS variables in `extra.css`.

### Theme Customizations
- **Logo**: Purdue branding (`assets/purdue.png`)
- **Favicon**: `assets/purdue_favicon.png`
- **Custom CSS**: `stylesheets/extra.css` (Purdue gold palette, UnitedSans font, table styles, hero banner, breadcrumbs, external link icons)
- **Overrides**: `overrides/main.html`

## Important Constraints

### Never Modify the Zensical Conda Environment
Do **not** edit any files inside `/home/jin456/.conda/envs/zensical/` (e.g., `zensical/markdown.py` or any installed library). If a Zensical bug requires a workaround, implement it in project files (`docs/`, `overrides/`, `zensical.toml`, CSS, JS).

### Zensical v0.0.29 Known Bugs
- **Frontmatter list/dict/bool values**: Rust core throws `TypeError: failed to extract field Markdown.meta` — workaround: comment out all frontmatter.
- **Template variables**: `page.is_homepage`, `lang.t()`, `page.file.src_uri` are not available in MiniJinja — workaround: use JS for runtime behavior.

## Key Files Reference
- `zensical.toml`: Main configuration, navigation, theme, plugins
- `requirements.txt`: Python dependencies
- `overrides/main.html`: Theme template override
- `docs/stylesheets/extra.css`: Custom styles
- `docs/assets/js/homepage.js`: Homepage TOC/layout fix
- `tools/Makefile`: Software catalog build automation
- `.github/workflows/`: CI/CD automation
- `.readthedocs.yaml`: Read the Docs build config

## Contact
- **Organization**: Rosen Center for Advanced Computing
- **Email**: rcac-help@purdue.edu
- **GitHub**: https://github.com/PurdueRCAC
- **Discord**: https://discord.gg/RmtKZmaQW9
