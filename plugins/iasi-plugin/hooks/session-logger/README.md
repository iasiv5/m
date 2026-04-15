---
name: 'Session Logger'
description: 'Logs all Copilot coding agent session activity for audit and analysis'
tags: ['logging', 'audit', 'analytics']
---

# Session Logger Hook
Comprehensive logging for GitHub Copilot coding agent sessions, tracking session starts, ends, and user prompts for audit trails and usage analytics.
面向 GitHub Copilot 编码代理会话的完整日志方案，跟踪会话开始、结束与用户提示词事件，用于审计留痕和使用分析。

## Overview

该 hook 提供 Copilot 编码代理活动的细粒度日志记录：
- 记录会话开始/结束时间，并附带工作目录上下文
- 记录用户提示词提交事件
- 记录代理响应事件（由 Stop hook 捕获）
- 支持可配置日志级别

## Features

- **会话追踪**：记录会话开始与结束事件
- **提示词日志**：记录用户完整提示词 (user prompt inputs)
- **响应日志**：按时间顺序记录助手响应内容 (agent responses)
- **自动回补**：Stop/reconcile 会从 transcript 自动补齐漏记事件
- **结构化日志**：使用 JSON 格式，便于解析
- **隐私可控**：支持通过配置完全关闭日志

## Installation

1. 进入当前项目的 `.github` 目录：
   ```bash
   cd .github
   ```

2. 克隆 hooks 仓库（仓库中包含 `hooks.json` 以及 `session-logger` 文件夹的全部内容）：
   ```bash
   git clone https://github.com/iasiv5/hooks.git
   ```

3. 创建日志目录：(可选，脚本会自动创建)
   ```bash
   mkdir -p ../logs/copilot
   ```

4. 在可执行权限受限的环境中，请确保脚本具备执行权限（按你的系统方式设置）

5. 将 hook 配置提交到仓库默认分支

## Log Format

会话事件会写入 `logs/copilot/session.log`。

提示词/响应事件只写入会话分片明细（事实源）：
- `logs/copilot/sessions/YYYY-MM-DD/YYYY-MM-DD_HHmmss-SESSION_ID-prompts.log`

如需全局视图，建议离线按需汇总会话分片文件，而非实时双写。

统一采用 JSON 格式：

```json
{"timestamp":"2024-01-15T10:30:00Z","event":"sessionStart","cwd":"/workspace/project"}
{"timestamp":"2024-01-15T10:35:00Z","event":"sessionEnd"}
{"timestamp":"2024-01-15T10:31:00Z","event":"userPromptSubmitted","sessionId":"...","eventId":"...","promptText":"..."}
{"timestamp":"2024-01-15T10:35:01Z","event":"agentResponse","sessionId":"...","eventId":"...","messageId":"...","response":"..."}
{"timestamp":"2024-01-15T10:35:02Z","event":"userPromptSubmitted","sessionId":"...","eventId":"...","promptText":"...","recovered":true,"recoverySource":"transcript"}
```

## Privacy & Security

- 将 `logs/` 加入 `.gitignore`，避免提交会话数据
- 使用 `LOG_LEVEL=ERROR` 仅记录错误
- 设置环境变量 `SKIP_LOGGING=true` 可禁用日志
- 日志仅保存在本地

## 来源说明

本项目中的 hooks 内容参考了以下原始实现，并在此基础上做了适配与优化：

https://github.com/github/awesome-copilot/tree/main/hooks/session-logger
