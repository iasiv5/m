This repository is a GitHub Copilot marketplace repository, not an application codebase.

Treat each `plugins/<plugin-name>/` folder as an installable plugin payload. Keep every plugin portable: prefer relative paths, avoid user-specific absolute paths, and do not assume the presence of `.claude`, `/memories`, or machine-local bootstrap state.

The primary runtime assets now live under `plugins/*/skills/`. When adding or modifying a skill, keep the parent folder name identical to the `name` field in `SKILL.md`, preserve referenced resource paths, and avoid introducing environment-specific setup unless it is clearly documented.

Keep the repository root lightweight and marketplace-focused:

- root `.github/plugin/marketplace.json` describes the marketplace
- runtime assets belong inside the smallest affected plugin subtree
- add `agents/`, `hooks`, or `.mcp.json` inside a plugin only when the use case truly requires them

Do not convert this repository into a generic workspace bootstrap repo. Optimize for reusable Copilot plugin assets that can be installed from a marketplace-style source repository.
