---
name: handoff
description: "为新的 GitHub Copilot chat 生成高保真交接上下文。适用于当前对话过长、已压缩、上下文质量下降，或用户明确要求 'handoff'、'交接一下'、'生成交接总结'、'新开 chat 接着做'、'create a handoff summary'、'continue in a new chat' 时。基于只读证据生成可直接粘贴到新 chat 的 HANDOFF CONTEXT。"
---

# Handoff Skill

Use this skill to create a self-contained, evidence-backed handoff summary for a fresh GitHub Copilot chat with minimal context loss.

## When to Use

Use this skill when:
- the current chat context is getting too long and quality is degrading
- the context window is approaching capacity
- the chat has been compacted, summarized, or partially compressed
- the user wants to start fresh while preserving essential context from this chat
- the user explicitly asks for a handoff, continuation summary, or new-chat context package

This is a strict handoff workflow.
Favor evidence over fluency.
Do not guess.

## Hard Invariants

- stay read-only while gathering evidence
- prefer direct evidence over recollection
- if an evidence source is unavailable, record that explicitly and use Unknown or None instead of guessing
- USER REQUESTS (AS-IS) and EXPLICIT CONSTRAINTS must be verbatim only
- include only requests or constraints that materially affect scope, implementation, validation, or remaining work
- do not include secrets, credentials, or tokens

## PHASE 0: VALIDATE REQUEST

Before proceeding, confirm:
- there is meaningful work or context in this chat to preserve
- the user wants a handoff summary now, not just a discussion about handoffs

If the chat is nearly empty or there is no meaningful context to preserve, say there is nothing substantial to hand off.

## PHASE 1: GATHER PROGRAMMATIC CONTEXT

Gather concrete evidence using only read-only actions.

Evidence priority, highest to lowest:
1. same-session history for the current chat, including earlier turns from the same session if the environment can read them
2. compacted, summarized, or pre-compaction history from the same session, if available
3. the current visible conversation
4. current todo state, if available
5. read-only git inspection
6. direct reads of files, plans, specs, test outputs, or instructions already referenced in the session

Mandatory evidence collection:
- inspect same-session history, including compacted or earlier turns, if available in this environment
- inspect the current visible conversation
- inspect current todo state, if available
- inspect read-only repository state using terminal commands when needed
- inspect only the minimum files needed to confirm important facts
- inspect active project instructions only if they materially constrained the work

Read-only terminal commands you may use when relevant:
- git diff --stat HEAD~10..HEAD
- git status --porcelain
- rg
- ls
- pwd

Suggested execution order:
1. inspect same-session history, including pre-compaction turns, if available
2. inspect the current visible conversation
3. inspect current todo state
4. inspect git diff/stat
5. inspect git status
6. confirm key files, plans, constraints, and decisions by reading only the necessary files

If same-session history or todo tooling is unavailable in this environment, start from the current visible conversation and record the missing source explicitly.
Inspect git or files only when those checks materially improve the handoff.

Analyze the gathered evidence to determine:
- what the user asked for, using exact wording
- what work was completed
- what work remains incomplete
- what decisions were made
- what files were modified, inspected, or established as important
- what constraints, preferences, or patterns were established
- what blockers, caveats, or unresolved questions remain

Evidence conflict rules:
- prefer same-session history over the currently visible chat when the chat has been compacted
- prefer direct file inspection over conversational recollection
- prefer git state over memory for changed-file claims
- prefer explicit user instructions over inferred preferences
- if two sources conflict and neither can be resolved, record the uncertainty instead of choosing one silently

Do not:
- edit files
- create files
- mutate git state
- run install, build, format, or test commands solely to enrich the handoff
- invent missing facts from memory
- convert weak inference into strong claims

If any evidence source is unavailable, record that explicitly and continue.

## PHASE 2: EXTRACT CONTEXT

Write the context summary from first person perspective:
- I asked...
- I changed...
- I decided...
- I found...

If a fresh chat could misread who acted, explicitly write User..., Agent..., or We... instead of I....

Focus on:
- capabilities and behavior, not file-by-file trivia
- what matters for continuing the work
- avoiding unnecessary low-level details unless they are critical
- preserving exact user requests and exact explicit constraints
- clearly separating verified facts from unknowns

Hard extraction rules:
- USER REQUESTS (AS-IS) must be verbatim only
- EXPLICIT CONSTRAINTS must be verbatim only
- include only requests or constraints that materially affect scope, implementation, validation, or remaining work
- omit older quoted material that no longer matters for continuation
- do not invent constraints, requests, decisions, file roles, or test results
- include file paths only when they matter for continuation
- if information is plausible but unverified, either omit it or label it Unknown where relevant
- do not paraphrase a user instruction if the exact wording matters

Questions to consider when extracting:
- what did I ask the agent to do?
- what did the agent actually complete?
- what remains pending?
- what files were changed, inspected, or declared important?
- what decisions, trade-offs, and constraints must carry forward?
- what should the next chat do first?
- what is the first concrete next action for the next chat?
- which quoted requests or constraints still materially matter?
- what risks, gotchas, or unknowns remain?

## PHASE 3: FORMAT OUTPUT

Generate a handoff summary using exactly this structure.
After HANDOFF CONTEXT, append the continuation instruction block from the final section.

HANDOFF CONTEXT
===============

USER REQUESTS (AS-IS)
---------------------
- [Exact verbatim user requests only]
- [Include only requests that materially affect scope, implementation, validation, or remaining work]
- [If none materially affect continuation, write: None]

GOAL
----
[One sentence or short paragraph describing what should be done next]

WORK COMPLETED
--------------
- [First-person bullet points only when the acting party is unambiguous]
- [If the actor could be ambiguous, explicitly write User, Agent, or We]
- [Include workspace-relative file paths when relevant]
- [Note key implementation or analysis decisions]

CURRENT STATE
-------------
- [Current state of the codebase or task]
- [Known build, test, or repo status only]
- [Relevant environment or configuration state]
- [Explicitly note unavailable evidence sources, if any]

PENDING TASKS
-------------
- [Planned but unfinished tasks]
- [Next logical steps]
- [Blockers, open questions, or issues encountered]
- [Include current todo state if available]
- [If nothing is pending, write: None]

KEY FILES
---------
- [path/to/file1] - [brief role description]
- [path/to/file2] - [brief role description]
- Maximum 10 files, prioritized by importance
- Prefer files confirmed by same-session history, git status, git diff/stat, or direct file inspection
- If no files are important for continuation, write: None

IMPORTANT DECISIONS
-------------------
- [Technical decisions and why they were made]
- [Trade-offs that were accepted]
- [Patterns or conventions that must be preserved]
- If there were no durable decisions, write: None

EXPLICIT CONSTRAINTS
--------------------
- [Verbatim constraints only, from the user or active project instructions]
- [Include only constraints that materially affect continuation]
- If none, write: None

CONTEXT FOR CONTINUATION
------------------------
- [What the next chat needs to know to continue]
- [First concrete next action: file, symbol, command, or cheapest validation step, when known]
- [Warnings, gotchas, and unresolved risks]
- [References to plans, specs, docs, outputs, or files if relevant]
- [If there is no additional continuation context, write: None]

Strict output rules:
- plain text with bullets
- inside HANDOFF CONTEXT, do not use markdown headings that start with #
- no bold, italic, or code fences inside the handoff content
- use workspace-relative file paths
- keep it continuation-oriented
- keep GOAL to one sentence or short paragraph
- do not exceed 10 files in KEY FILES
- do not include secrets, credentials, or tokens
- include only verbatim requests or constraints that materially affect continuation
- do not paraphrase USER REQUESTS (AS-IS)
- do not paraphrase EXPLICIT CONSTRAINTS
- do not claim a build or test passed unless that evidence already exists in the session or in outputs you directly inspected
- if evidence is missing, say Unknown rather than guessing

## CONTINUATION BLOCK

After generating HANDOFF CONTEXT, add this instruction block:

TO CONTINUE IN A NEW GITHUB COPILOT CHAT:

1. Open a new Copilot chat in VS Code.
2. Paste the HANDOFF CONTEXT above as the first message.
3. Add your request: Continue from the handoff context above. [Your next task]

The new chat should have enough context to continue with minimal loss.

## IMPORTANT CONSTRAINTS

- DO NOT attempt to programmatically create a new chat
- DO provide a self-contained summary that works without access to this chat
- DO include workspace-relative file paths
- DO NOT include sensitive information
- DO NOT exceed 10 files in the KEY FILES section
- DO keep the GOAL section short
- DO remain read-only while gathering evidence
- DO prefer same-session history over only the currently visible chat when the chat has been compacted

## EXECUTE NOW

Begin by gathering programmatic context, then synthesize the handoff summary.

If the user supplied extra instructions when invoking this skill, use them only to sharpen GOAL, PENDING TASKS, or the first concrete next action.
Do not rewrite quoted user requests or explicit constraints.