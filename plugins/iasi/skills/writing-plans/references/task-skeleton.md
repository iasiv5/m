# Task Skeleton

下面是推荐的任务结构。对代码任务优先使用这个骨架；对非代码任务，也要保留“改动前检查 / 改动后验证”的思路。

## 任务标题

`### Task N: [任务名称]`

## 目标

- 用一句话说明这个任务完成什么

## Files

- Create: `exact/path/to/file`
- Modify: `exact/path/to/existing-file`（可附符号或章节锚点）
- Test: `tests/path/to/test-file`

## Step 1: 写失败测试或失败检查

```text
[放入真实测试代码、检查命令或观察条件]
```

## Step 2: 运行并确认当前失败

- Run: `exact command`
- Expected: [明确失败信号]

## Step 3: 写最小实现

```text
[放入真实实现代码、配置片段或文档修改内容]
```

## Step 4: 运行并确认通过

- Run: `exact command`
- Expected: [明确通过信号]

## Step 5: 可选 checkpoint commit

- Run: `git add ... && git commit -m "..."`
- Expected: commit 成功

## 额外规则

- 路径必须精确
- 行号可以作为辅助，但不要把行号当成唯一定位方式
- 每个步骤都要写出真实内容，不要把关键实现留给执行者猜
- 如果任务不适合严格 TDD，也要写出改动前检查和改动后验证