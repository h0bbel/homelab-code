# Changelog

## [1.2.4] - 01-08-2025
### Changed
- Reworked uptime reporting to only show actual uptime for running containers. For stopped containers, uptime now displays `(n/a)`.
- Improved clarity in uptime formatting.
- Bumped version from 1.2.3 to 1.2.4.

## [1.2.3] - 01-08-2025
### Added
- Summary section added to the report:
  - Total environments (endpoints)
  - Total stacks
  - Total containers (running and stopped breakdown)

## [1.2.2] - 01-08-2025
### Added
- Container uptime shown as relative time (e.g. 5h, 30m)

## [1.2.1] - 30-07-2025
### Added
- Support for `USE_INSECURE_SSL` in `.env` to allow insecure SSL certs with curl

## [1.2.0] - 28-07-2025
### Added
- Support for loading configuration from `.env` file
- Optional custom header support via `templates/header.md`

## [1.1.0] - 20-07-2025
### Added
- Group containers by stack and state (running/stopped)
- Volume and network information added to container details
- Output to markdown file with clear sections and formatting
