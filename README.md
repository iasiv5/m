# iasi plugin

这是一个最小可用的 GitHub Copilot plugin 仓库。

当前版本包含两类可复用资产：

- `code-review` skill
- `session-logger` hook

`code-review` 以 Agent Skill 的形式提供结构化代码审查流程。
`session-logger` 通过 hooks 记录会话与提示词事件，便于审计和分析。

## 当前结构

```text
.
├── plugin.json
├── hooks.json
├── .github/
│   ├── copilot-instructions.md
│   ├── plugin/
│   │   └── marketplace.json
│   └── hooks/
│       └── session-logger/
└── skills/
  └── code-review/
        ├── SKILL.md
    └── resources/
```

## 为什么先做成这个形态

- 根目录 `plugin.json` 是单插件仓库安装的必需清单。
- VS Code 的 GitHub Copilot agent plugin 可以直接从插件根目录读取 `skills/`。
- `hooks.json + .github/hooks/` 的目录布局与官方常见 plugin/hook 组织方式保持一致。
- `.github/plugin/marketplace.json` 用于作为插件市场源时的索引信息。
- 这样可以保证 `plugin/` 作为独立仓库上传后，以较小配置成本启用 skill 与 hook。

## 安装方式

### 方式一：从 Git 仓库安装

1. 在 VS Code 中启用 `chat.plugins.enabled`。
2. 执行命令 `Chat: Install Plugin From Source`。
3. 输入这个 `plugin` 仓库上传后的 GitHub URL。

### 方式二：本地目录注册

在 VS Code 设置中添加：

```json
{
  "chat.pluginLocations": {
    "d:/git-repo/ai-workspace-assets/plugin": true
  }
}
```

## 使用方式

- 在聊天中直接输入 `/code-review` 手动调用。
- 或在你发起代码审查请求时，让 Copilot 根据 skill 描述自动加载。
- 会话期间，hook 会按 `hooks.json` 配置自动记录日志事件。

## 当前边界

- 已包含：1 个 skill 与 1 组 hook（session-logger）。
- 未包含：自定义 agent、prompt、MCP server。
- 未包含：任何依赖用户私有目录（如 `~/.claude/`）的安装逻辑。

## 后续建议

如果你后续想把现有 `prompts/` 里的工作流继续迁入 plugin，建议优先按以下顺序演进：

1. 把路由型 prompt 改造成 `agents/` 下的自定义 agent。
2. 把与环境初始化强绑定的 prompt 拆成更通用的 skill 或 agent。
3. 只有在确实需要外部命令或系统集成时，再增加 hooks 或 MCP。