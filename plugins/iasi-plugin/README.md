# iasi-plugin

`iasi-plugin` 是当前 marketplace 里的第一个 GitHub Copilot 插件。

它包含以下可复用资产：

- `story-generator` custom agent
- `code-review` skill
- `session-logger` hook
- `create-git-commit-message-IEC` command prompt
- `python-cli-scripts` path-specific instruction

`code-review` 提供结构化代码审查流程，`session-logger` 负责记录会话与提示词事件，便于审计和分析。

## 插件结构

```text
.
├── .github/plugin/plugin.json
├── agents/
│   └── story-generator.agent.md
├── commands/
│   └── create-git-commit-message-IEC.prompt.md
├── hooks/
│   ├── hooks.json
│   └── session-logger/
├── instructions/
│   └── python-cli-scripts.instructions.md
└── skills/
    └── code-review/
        ├── SKILL.md
        └── resources/
```

## 安装方式

请把仓库 `iasiv5/plugin` 作为 marketplace 源添加，再选择安装其中的 `iasi-plugin`。

如果只添加了 marketplace 源，但没有继续选择插件项，插件不会自动启用。

## 使用方式

- 在聊天中直接输入 `/code-review` 手动调用
- 或在你发起代码审查请求时，让 Copilot 根据 skill 描述自动加载
- 会话期间，hook 会按 `hooks/hooks.json` 配置自动记录日志事件

## 当前边界

- 已包含：1 个 custom agent、1 个 skill、1 组 hook（session-logger）、1 个 command prompt、1 条 path-specific instruction
- 未包含：MCP server
- 未包含：依赖本地绝对安装路径的分发逻辑
