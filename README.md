# iasiv5 Copilot Marketplace

这是一个 GitHub Copilot marketplace 风格仓库：根目录负责暴露 marketplace 元数据，实际可安装插件放在 `plugins/` 下。

当前已提供 1 个插件：

| Plugin | Included assets |
| --- | --- |
| `iasi-plugin` | `story-generator` agent、`code-review` skill、`session-logger` hook、`create-git-commit-message-IEC` command prompt、`python-cli-scripts` instruction |

## 仓库结构

```text
.
├── .github/
│   ├── copilot-instructions.md
│   └── plugin/
│       └── marketplace.json
├── plugins/
│   └── iasi-plugin/
│       ├── .github/plugin/plugin.json
│       ├── agents/
│       ├── commands/
│       ├── hooks/
│       ├── instructions/
│       ├── skills/
│       └── README.md
├── INSTALL.md
└── README.md
```

## 架构说明

- 根目录 `.github/plugin/marketplace.json` 声明 marketplace，并通过 `pluginRoot: "./plugins"` 暴露子插件。
- 每个插件在 `plugins/<name>/` 下自包含自己的 runtime 资产和 `.github/plugin/plugin.json`。
- 这种结构与 `awesome-copilot` 的多插件分发方式一致，后续新增第二个、第三个插件时不需要再重构根目录。

## 安装方式

请把仓库 `iasiv5/plugin` 当作 marketplace 源添加，然后选择安装其中的 `iasi-plugin`。

详细安装步骤见 [`INSTALL.md`](INSTALL.md)。

## 当前边界

- 已包含：1 个 custom agent、1 个 skill、1 组 hook（session-logger）、1 个 command prompt、1 条 path-specific instruction
- 未包含：MCP server
- 未包含：依赖用户本地绝对安装路径的分发结构

## 后续新增插件

后续新增插件时，只需要：

1. 创建 `plugins/<new-plugin>/`
2. 添加 `plugins/<new-plugin>/.github/plugin/plugin.json`
3. 把该插件资产放到自己的目录里
4. 在根 `.github/plugin/marketplace.json` 追加一条插件记录

`iasi-plugin` 的插件级说明见 [`plugins/iasi-plugin/README.md`](plugins/iasi-plugin/README.md)。
