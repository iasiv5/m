# iec-plugin-demo

`iec-plugin-demo` 是当前 marketplace 里的示例 GitHub Copilot 插件，聚焦高标准只读分析与结构化代码审查。

它包含以下可复用资产：

- `ask-pro-max` custom agent
- `code-review` skill
- `ask-pro-max` command prompt
- `python-cli-scripts` path-specific instruction
- `hooks/hooks.json` 空 hooks 占位文件

`ask-pro-max` 用于高标准、只读的问题分析；`code-review` 提供结构化代码审查流程，用于规范化和系统化的代码质量评估。

## 插件结构

```text
.
├── .github/plugin/plugin.json
├── agents/
│   └── ask-pro-max.agent.md
├── commands/
│   └── ask-pro-max.prompt.md
├── hooks/
│   └── hooks.json
├── instructions/
│   └── python-cli-scripts.instructions.md
├── CHANGELOG.md
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
- 在聊天中输入 `/` 后选择 `Ask Pro Max` command prompt
- 或在你发起代码审查请求时，让 Copilot 根据 skill 描述自动加载

## 当前边界

- 已包含：1 个 custom agent、1 个 skill、1 个 command prompt、1 条 path-specific instruction、1 个空 hooks 占位文件
- 未包含：非空 hooks 实现
- 未包含：MCP server
- 未包含：依赖本地绝对安装路径的分发逻辑
