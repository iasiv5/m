# iasi

`iasi` 是当前 marketplace 里的 GitHub Copilot 插件，提供需求澄清、实施规划、工程设计、交接、知识沉淀、复盘和 agent 文档写作等 skills，以及 `goal-driven` 命令。

它包含以下可复用资产：

- 3 个本地适配 skills：`brainstorming`、`writing-plans`、`handoff`
- 7 个上游同步 skills：`grilling`、`codebase-design`、`domain-modeling`、`grill-with-docs`、`improve-codebase-architecture`、`retro`、`writing-for-agents`
- `goal-driven` command prompt
- `copilot-thought-logging` workspace-wide instruction
- `hooks/hooks.json` 空 hooks 占位文件

本地适配的三个 skills 用于需求澄清、实施计划和交接；上游同步的七个 skills 保持原版英文标准 SKILL.md，覆盖方案拷打、深模块设计、领域建模、架构改进、复盘和 agent 文档写作等场景。`goal-driven` 命令是纯模板组装器：把用户给出的 goal 与可验证 criteria 组装成一份可部署的 Goal-Driven master/subagent 提示词（含可验证性门禁；组装器本身不运行循环）。

## 插件结构
```text
.
├── .github/plugin/plugin.json
├── commands/
│   └── goal-driven.prompt.md
├── hooks/
│   └── hooks.json
├── instructions/
│   └── copilot-thought-logging.instructions.md
├── ATTRIBUTIONS.md
├── CHANGELOG.md
└── skills/
    ├── .your-skill-collection.json
    ├── update.sh
    ├── brainstorming/
    ├── writing-plans/
    ├── handoff/
    ├── grilling/
    ├── codebase-design/
    ├── domain-modeling/
    ├── grill-with-docs/
    ├── improve-codebase-architecture/
    ├── retro/
    └── writing-for-agents/

```

## 安装方式

请把仓库 `iasiv5/m` 作为 marketplace 源添加，再选择安装其中的 `iasi` 插件。

如果只添加了 marketplace 源，但没有继续选择插件项，插件不会自动启用。

## 使用方式

- 在聊天中直接输入 `/brainstorming`、`/writing-plans`、`/handoff`、`/grilling`、`/codebase-design`、`/domain-modeling`、`/grill-with-docs`、`/improve-codebase-architecture`、`/retro` 或 `/writing-for-agents` 手动调用 skill
- 在聊天中输入 `/` 后选择 `goal-driven` command prompt
- 或在你发起需求澄清、实施规划、工程设计、交接总结、知识整理、复盘或 agent 文档写作等请求时，让 Copilot 根据资产描述自动加载

## 当前边界

- 已包含：10 个 skills（3 本地适配 + 7 上游同步）、1 个 command prompt、1 条 workspace-wide instruction、1 个空 hooks 占位文件；不含 custom agents
- 未包含：非空 hooks 实现
- 未包含：MCP server
- 未包含：依赖本地绝对安装路径的分发逻辑
