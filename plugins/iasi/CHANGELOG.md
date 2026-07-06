# Changelog

All notable changes to `iasi` will be documented in this file.

## [5.6.2] - 2026-07-06

### Added

- Synced five upstream mattpocock skills into `skills/`: `grilling`, `codebase-design`, `domain-modeling`, `grill-with-docs`, and `improve-codebase-architecture`.
- Added `skills/.your-skill-collection.json` and `skills/update.sh` to keep upstream skill sync reproducible.
- Added benchmark assets for local planning skills: `test-prompts.json` and `results.tsv` under `brainstorming` and `writing-plans`.

### Changed

- Updated `brainstorming` and `writing-plans` skill prompts/rules to improve mixed-intent routing, design-path coverage, and self-review constraints.
- Refreshed plugin and marketplace documentation to match the current published asset inventory.

## [5.6.1] - 2026-07-03

### Changed

- Extended the published `cleanup` skill with conservative repository-rule governance auditing, including safe auto-fix vs. user-decision boundaries.
- Added a GitHub Copilot-specific cleanup governance reference and updated cleanup reference matrices for instruction entrypoints, published asset lists, dead references, and metadata consistency.
- Bumped the published plugin version metadata to `5.6.1`.

## [5.6.0] - 2026-05-18

### Added

- Added the published `cleanup` skill for end-of-task long-term knowledge cleanup and repository-scoped knowledge reconciliation.

### Changed

- Defined `cleanup` as a conservative, final-state knowledge-synchronization skill that stays separate from `handoff` and normal in-flight document updates.
- Updated plugin documentation, marketplace documentation, plugin metadata, and marketplace metadata so they reflect two published agents, four published skills, and one reusable command prompt.
- Bumped the published plugin version metadata to `5.6.0` in both the plugin manifest and marketplace entry.

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
