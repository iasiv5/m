# Changelog

All notable changes to `iasi` will be documented in this file.

## [5.5.0] - 2026-05-16

### Added

- Published the `plan-pro-max` custom agent as a user-invocable design-first planning mode.

### Changed

- Reworked `plan-pro-max` from the stock Plan agent body into a design-first workflow with explicit design approval, one-question-at-a-time clarification, option comparison, strongest-counterargument checks, and post-approval implementation planning.
- Updated plugin documentation, marketplace documentation, plugin metadata, and marketplace metadata so they reflect two published agents, three published skills, and one reusable command prompt.
- Bumped the published plugin version metadata to `5.5.0` in both the plugin manifest and marketplace entry.

## [5.4.0] - 2026-05-15

### Removed

- Removed the published `code-review` skill and its bundled review reference files from the plugin package.

### Changed

- Updated plugin metadata, marketplace metadata, README inventories, and installation guidance so they reflect three published skills and one reusable command prompt.
- Bumped the published plugin version metadata to `5.4.0` in both the plugin manifest and marketplace entry.

## [5.3.0] - 2026-05-15

### Added

- Added the published `brainstorming` skill for manual-first requirement clarification and design document generation.
- Added the published `writing-plans` skill for turning approved designs or clear requirements into executable implementation plans.

### Changed

- Adapted the new planning skills for GitHub Copilot packaging with Chinese-first prompts, local interface metadata, and lightweight `references/` templates.
- Explicitly excluded the Superpowers Visual Companion runtime assets and downstream execution/branch-finishing skills from this first published planning workflow.
- Updated plugin metadata, marketplace entry, README inventories, and installation guidance so they reflect four published skills and one reusable command prompt.
- Bumped the published plugin version metadata to `5.3.0` in both the plugin manifest and marketplace entry.

## [5.2.1] - 2026-05-14

### Changed

- Switched the published `handoff` skill to a bilingual Chinese-English fixed output skeleton while keeping handoff body content Chinese-first by default.
- Bumped the published plugin version metadata to `5.2.1` in both the plugin manifest and marketplace entry.

## [5.2.0] - 2026-05-14

### Changed

- Localized the published `handoff` skill body and output skeleton into Chinese while keeping the single-file structure and conservative routing boundary.
- Bumped the published plugin version metadata to `5.2.0` in both the plugin manifest and marketplace entry.

## [5.1.0] - 2026-05-14

### Added

- Added the published `handoff` skill for evidence-backed new-chat handoff summaries.

### Removed

- Removed the published `handoff` command prompt in favor of the `handoff` skill.

### Changed

- Updated marketplace metadata, plugin metadata, and installation documentation to use the new plugin name consistently.

## [5.0.0] - 2026-05-14

### Changed

- Renamed the published plugin to `iasi`.
- Updated marketplace metadata, plugin metadata, and installation documentation to use the new plugin name consistently.