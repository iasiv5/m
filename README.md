# iasiv5 Copilot Marketplace

这是一个 GitHub Copilot 插件市场（Marketplace）仓库，用于分发仓库内的 Copilot 插件。

当前提供以下插件：

| 插件 | 包含内容 |
| --- | --- |
| `iec-plugin-demo` | `Ask Pro Max` agent、`code-review` skill、`Ask Pro Max` 命令、`copilot-thought-logging` instruction，以及 hooks 占位资源 |

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

请将仓库 `iasiv5/m` 添加为插件市场（Marketplace）源，然后在其中安装 `iec-plugin-demo`。

### 前提

- VS Code 版本支持 GitHub Copilot Agent Plugins（预览）
- 已开启设置 `chat.plugins.enabled`

### 安装步骤

当前仓库采用插件市场结构，根目录不再作为单个插件直接安装；请通过插件市场入口安装其中的子插件。

1. 在 GitHub Copilot 的插件市场入口中添加仓库 `iasiv5/m`
2. 在该插件市场中选择并安装 `iec-plugin-demo`
3. 完成安装后，重新打开一个 Copilot Chat 会话

### 验证

- 打开 Copilot Chat 的插件列表，确认 `iec-plugin-demo` 已启用
- 输入 `/`，确认可以看到 `code-review` 和 `Ask Pro Max`
- 发送一条代码审查请求，或手动触发 `Ask Pro Max`，确认相关插件资产可正常调用

### 常见问题

如果出现“这似乎不是有效的插件市场”：

1. 确认远程仓库包含根目录 `.github/plugin/marketplace.json`
2. 刷新或重试安装入口，避免命中旧缓存
3. 确认你已在插件市场列表中继续选择并安装 `iec-plugin-demo`

如果你只是添加了仓库源，但没有继续选择插件项，插件不会自动启用。

如需查看 `iec-plugin-demo` 的详细说明，请见 [`plugins/iec-plugin-demo/README.md`](plugins/iec-plugin-demo/README.md)。
