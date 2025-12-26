# Integrations

为常见多代理/IDE 适配的落地指引。核心原则：先隔离审计（本仓库流程），PASS 后再放入各自的“生效目录”，或以配置/Prompt 方式调用。

## Codex
- 使用本仓库的 `SKILL.md` 直接作为 Skill；推荐放入 `~/.codex/skills/security-preflight/`（或按 Codex 约定路径）。
- 安装第三方 Skill 前：先 clone 至 `~/temp_skills_quarantine/<name>`，按 `SKILL.md` 审计，PASS 后再移动到 `~/.codex/skills/<name>`。

## Claude Code
- 将审计 SOP 作为预置 Prompt：要求在安装/运行外部脚本、扩展或技能前，先执行隔离审计流程。
- 若需要本地副本，可在工作区保留 `SKILL.md`，由 Claude Code 引用其中的审计模板和 `rg` 命令。

## Antigravity
- 在工作区添加此仓库（或复制 `SKILL.md`、`README.md`）供 Agent 引用。
- 配置安装脚本/任务前，先在隔离目录跑审计，PASS 后再将目标代码放入 Antigravity 的执行路径或工作区。

## Cursor
- 在工作区根目录保留 `SKILL.md` 与 `README.md`，并通过 Prompt 明确：安装依赖或运行下载代码前，必须先执行隔离审计。
- 如需脚本化，可把 `rg` 命令片段加入自定义任务/快捷命令，指向隔离目录。

## 通用提示
- 生效路径因产品/版本而异，若不确定路径，保持审计过程在隔离目录进行；通过人工确认后再复制到目标路径。
- 不要在隔离目录执行 `npm/pip install`、构建或运行脚本，直到审计 PASS。
