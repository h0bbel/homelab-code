# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [1.2.2] - 2025-07-31
### Added
- Uptime column in Markdown report (relative time using `State.StartedAt`)

---

## [1.2.1] - 2025-07-31
### Added
- `USE_INSECURE_SSL` option in `.env` for skipping SSL verification
- MIT License header with author credit

### Changed
- Markdown formatting cleanup
- Output improved for empty stacks and containers
- Consistent fallback values for missing data

---

## [1.2.0] - 2025-07-30
### Added
- Full Markdown inventory output grouped by stack and container state
- Support for `header.md` inclusion via `templates/header.md`
- Markdown tables now include volume and network data
- Orphaned containers section

### Changed
- All sensitive config moved to `.env` file
- Improved authentication failure handling
- Simplified and consistent terminal output

---

## [1.0.0] - 2025-07-27
### Added
- Initial version of script to query Portainer API and output containers
- Basic table structure grouped by endpoint
