# 安装与启用

## 前提

- VS Code 版本支持 GitHub Copilot Agent Plugins（预览功能）
- 已开启设置 `chat.plugins.enabled`

## 作为 marketplace 仓库安装

当前仓库已经调整为 marketplace 结构，根目录不再作为单个插件直接安装；请通过 marketplace 入口安装其中的子插件。

1. 在支持 marketplace 的入口添加仓库 `iasiv5/m`
2. 在该 marketplace 中选择并安装插件 `iec-plugin-demo`
3. 完成安装后重新打开一个 Copilot Chat 会话

## 验证

- 打开 Chat 的插件列表，确认 `iec-plugin-demo` 已启用
- 输入 `/`，确认能看到 `code-review`
- 发送一条代码审查请求，检查 skill 是否被调用
- 执行一次会话后，确认 hook 已在工作区 `logs/copilot/` 下写入日志（如启用了日志）

## 常见问题

如果提示“这似乎不是有效的插件市场”：

1. 确认远程仓库已包含根目录 `.github/plugin/marketplace.json`
2. 刷新/重试安装入口，避免命中旧缓存
3. 确认你已经在 marketplace 列表中继续选择并安装 `iec-plugin-demo`

如果你只是添加了仓库源，但没有继续选择插件项，插件不会自动启用。
