# iec-plugin-demo

`iec-plugin-demo` 是当前 marketplace 里的第一个 GitHub Copilot 插件。

它包含以下可复用资产：

- `story-generator` custom agent
- `ask-pro-max` custom agent
- `code-review` skill
- `create-git-commit-message-IEC` command prompt
- `ask-pro-max` command prompt
- `python-cli-scripts` path-specific instruction

`code-review` 提供结构化代码审查流程，用于规范化和系统化的代码质量评估。

## 插件结构

```text
.
├── .github/plugin/plugin.json
├── agents/
│   ├── ask-pro-max.agent.md
│   └── story-generator.agent.md
├── commands/
│   ├── ask-pro-max.prompt.md
│   └── create-git-commit-message-IEC.prompt.md
├── hooks/
│   └── hooks.json
├── instructions/
│   └── python-cli-scripts.instructions.md
└── skills/
    └── code-review/
        ├── SKILL.md
        └── resources/
```

## 安装方式

请把仓库 `iasiv5/m` 作为 marketplace 源添加，再选择安装其中的 `iec-plugin-demo`。

如果只添加了 marketplace 源，但没有继续选择插件项，插件不会自动启用。

## 使用方式

- 在聊天中直接输入 `/code-review` 手动调用
- 在聊天中输入 `/` 后选择 `Ask Pro Max` 或 `create-git-commit-message-IEC` command prompt
- 或在你发起代码审查请求时，让 Copilot 根据 skill 描述自动加载

## 当前边界

- 已包含：2 个 custom agent、1 个 skill、2 个 command prompt、1 条 path-specific instruction
- 未包含：hooks 实现
- 未包含：MCP server
- 未包含：依赖本地绝对安装路径的分发逻辑
