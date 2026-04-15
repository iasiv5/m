---
description: "Use when creating or editing Python CLI automation scripts under scripts/. Covers the repo's script-first pattern, argparse-based CLIs, prerequisite checks, nearby README updates, and minimal smoke validation."
name: "Python CLI Scripts"
applyTo: "scripts/**/*.py"
---

# Python CLI Script Guidelines

- Treat the following rules as hard requirements for files matched by scripts/**/*.py.
- Preserve the repo's script-first style. Extend an existing entry point under scripts/ before adding a parallel tool or framework.
- Keep each script runnable as a clear CLI entry point. Use argparse-style flags and Windows-friendly path examples in help text and documentation.
- Check external prerequisites early and fail with an exact next action, such as installing ffmpeg, playwright browsers, or faster-whisper.
- Keep generated operational data local to the workspace. Do not treat logs under logs/copilot/ as source files unless the task is specifically about logging behavior.
- When flags, outputs, prerequisites, or defaults change, update the nearby README or documented command if one exists.
- Validate only the changed script or its documented smoke command. Do not invent repo-wide build, lint, or test steps.
- Preserve existing Chinese labels, report titles, and output filename conventions where they already exist.