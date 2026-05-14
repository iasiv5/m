# iasiv5 Copilot Marketplace

这是一个 GitHub Copilot marketplace 仓库

当前已提供 1 个插件：

| Plugin | Included assets |
| --- | --- |
| `iec-plugin-demo` | `ask-pro-max` agent、`code-review` skill、`ask-pro-max` command prompt、`copilot-thought-logging` instruction、空 hooks 占位 |

## 仓库结构
```text
.
├── .github/
│   ├── copilot-instructions.md
│   └── plugin/
│       └── marketplace.json
├── plugins/
│   └── iec-plugin-demo/
├── INSTALL.md
└── README.md
```

## 安装与启用

请将仓库 `iasiv5/m` 作为 marketplace 源添加，并在其中选择安装 `iec-plugin-demo`。

### 前提

- VS Code 版本支持 GitHub Copilot Agent Plugins（预览功能）
- 已开启设置 `chat.plugins.enabled`

### 安装步骤

当前仓库采用 marketplace 结构，根目录不再作为单个插件直接安装；请通过 marketplace 入口安装其中的子插件。

1. 在支持 marketplace 的入口添加仓库 `iasiv5/m`
2. 在该 marketplace 中选择并安装插件 `iec-plugin-demo`
3. 完成安装后重新打开一个 Copilot Chat 会话

### 验证

- 打开 Chat 的插件列表，确认 `iec-plugin-demo` 已启用
- 输入 `/`，确认能看到 `code-review` 和 `Ask Pro Max`
- 发送一条代码审查请求，或手动触发 `Ask Pro Max`，检查插件资产是否可被调用

### 常见问题

如果提示“这似乎不是有效的插件市场”：

1. 确认远程仓库已包含根目录 `.github/plugin/marketplace.json`
2. 刷新或重试安装入口，避免命中旧缓存
3. 确认你已经在 marketplace 列表中继续选择并安装 `iec-plugin-demo`

如果你只是添加了仓库源，但没有继续选择插件项，插件不会自动启用。

`iec-plugin-demo` 的插件级说明见 [`plugins/iec-plugin-demo/README.md`](plugins/iec-plugin-demo/README.md)。
