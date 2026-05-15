# Plan Template

使用下面的骨架写实施计划；按任务复杂度增删细节，但不要删掉核心执行信息。

## 文档标题

`# [功能名称] 实施计划`

## 目标

- 这份计划要完成什么

## 架构快照

- 本次采用什么思路
- 和现有结构如何衔接

## 输入工件

- 设计文档路径
- 相关需求或补充说明

## 文件结构与职责

- Create: `path/to/new-file`
- Modify: `path/to/existing-file`（可附符号或章节锚点）
- Test: `path/to/test-file`

## 任务清单

### Task 1: [任务名称]

- 目标
- 涉及文件
- 验证范围

- [ ] Step 1: 写失败测试或失败检查
- [ ] Step 2: 运行并确认失败
- [ ] Step 3: 写最小实现
- [ ] Step 4: 运行并确认通过
- [ ] Step 5: 可选 checkpoint commit

## 执行纪律

- 开始实现前先复查计划
- 每任务都要验证
- 遇阻立即停下说明

## 最终验证

- 需要运行的最终测试或检查
- 预期结果

默认路径优先级：用户指定路径 > 仓库已有约定 > `docs/plans/<YYYY-MM-DD>-<feature>-implementation-plan.md`。