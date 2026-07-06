# iasi

`iasi` 是当前 marketplace 里的 GitHub Copilot 插件，聚焦高标准只读分析、设计优先规划、高保真交接、终态长期知识沉淀与规则审计。

它包含以下可复用资产：

- `ask-pro-max` custom agent
- `plan-pro-max` custom agent
- 4 个本地适配 skills：`brainstorming`、`writing-plans`、`handoff`、`cleanup`
- 5 个上游同步 skills：`grilling`、`codebase-design`、`domain-modeling`、`grill-with-docs`、`improve-codebase-architecture`
- `ask-pro-max` command prompt
- `copilot-thought-logging` workspace-wide instruction
- `hooks/hooks.json` 空 hooks 占位文件

`ask-pro-max` 用于高标准、只读的问题分析；`plan-pro-max` 用于先收敛设计、比较方案、获得明确批准后再输出实施计划；本地适配的四个 skills 用于需求澄清、实施计划、交接和终态沉淀；上游同步的五个 skills 保持原版英文标准 SKILL.md，覆盖深模块设计、领域建模、方案拷打与架构改进等场景。

## 插件结构
```text
.
├── .github/plugin/plugin.json
├── agents/
│   ├── ask-pro-max.agent.md
│   └── plan-pro-max.agent.md
├── commands/
│   └── ask-pro-max.prompt.md
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
    ├── cleanup/
    ├── grilling/
    ├── codebase-design/
    ├── domain-modeling/
    ├── grill-with-docs/
    └── improve-codebase-architecture/

```

## 安装方式

请把仓库 `iasiv5/m` 作为 marketplace 源添加，再选择安装其中的 `iasi` 插件。

如果只添加了 marketplace 源，但没有继续选择插件项，插件不会自动启用。

## 使用方式

- 在聊天中直接输入 `/brainstorming`、`/writing-plans`、`/handoff`、`/cleanup`、`/grilling`、`/codebase-design`、`/domain-modeling`、`/grill-with-docs` 或 `/improve-codebase-architecture` 手动调用 skill
- 在 agent mode 选择器中切换到 `Plan Pro Max` 进行 design-first 规划，或切换到 `Ask Pro Max` 进行高标准只读分析
- 在聊天中输入 `/` 后选择 `Ask Pro Max` command prompt
- 或在你发起需求澄清、实施计划、交接总结、最终沉淀或只读分析等请求时，让 Copilot 根据资产描述自动加载

## 当前边界

- 已包含：2 个 custom agents、9 个 skills（4 本地适配 + 5 上游同步）、1 个 command prompt、1 条 workspace-wide instruction、1 个空 hooks 占位文件
- 未包含：非空 hooks 实现
- 未包含：MCP server
- 未包含：依赖本地绝对安装路径的分发逻辑
