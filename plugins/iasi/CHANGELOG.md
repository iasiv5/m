# Changelog

All notable changes to `iasi` will be documented in this file.

## [5.0.0] - 2026-05-14

### Changed

- Renamed the published plugin to `iasi`.
- Updated marketplace metadata, plugin metadata, and installation documentation to use the new plugin name consistently.

## [4.0.1] - 2026-05-09

### Added

- Added the published `copilot-thought-logging` workspace-wide instruction.

### Removed

- Removed the published `python-cli-scripts` path-specific instruction.

### Changed

- Updated the plugin README inventory, structure snapshot, and boundary notes so they match the remaining published assets.

## [4.0.0] - 2026-05-08

### Removed

- Removed the published `create-git-commit-message-IEC` command prompt.

### Changed

- Updated marketplace metadata, plugin metadata, installation checks, and README inventories to reflect that `ask-pro-max` is now the only published command prompt.

## [3.0.0] - 2026-05-08

### Removed

- Removed the `story-generator` custom agent from the published plugin payload.

### Changed

- Simplified marketplace metadata, plugin metadata, and README inventories so they match the remaining assets.
- Kept `ask-pro-max`, `code-review`, two command prompts, one path-specific instruction, and an empty hooks placeholder as the published surface for `3.0.0`.

## [2.1.0] - 2026-05-08

### Added

- Added `ask-pro-max` custom agent for read-only, high-rigor question answering.
- Added `ask-pro-max` command prompt for slash-command invocation.

### Changed

- Set balanced-mode as the default Ask Pro Max behavior, with explicit sharp-mode trigger support.
- Updated plugin metadata to advertise the new Ask Pro Max agent and prompt.
- Updated README asset inventory, plugin structure, and usage notes to reflect the new plugin contents.
