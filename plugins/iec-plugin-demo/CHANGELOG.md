# Changelog

All notable changes to `iec-plugin-demo` will be documented in this file.

## [3.0.0] - 2026-05-08

### Removed

- Removed the `story-generator` custom agent from the published plugin payload.

### Changed

- Simplified marketplace metadata, plugin metadata, and README inventories so they match the remaining assets.
- Kept `ask-pro-max`, `code-review`, two command prompts, one path-specific instruction, and an empty hooks placeholder as the current published surface.

## [2.1.0] - 2026-05-08

### Added

- Added `ask-pro-max` custom agent for read-only, high-rigor question answering.
- Added `ask-pro-max` command prompt for slash-command invocation.

### Changed

- Set balanced-mode as the default Ask Pro Max behavior, with explicit sharp-mode trigger support.
- Updated plugin metadata to advertise the new Ask Pro Max agent and prompt.
- Updated README asset inventory, plugin structure, and usage notes to reflect the new plugin contents.
