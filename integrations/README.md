# 集成指南索引

本仓库的核心是“隔离 + 审计 + 决策门控（PASS/FAIL）”。不同产品最好的落地方式不一样：

- Codex：作为 Skill 使用（见 `codex.md` / `../SKILL.md`）。
- Claude Code：作为固定的“前置安全检查 SOP / System Prompt”使用（见 `claude-code.md`）。
- Cursor：作为 Project Rules（项目规则）使用，把规则写进项目，让 Cursor 在执行/安装前强制走审计（见 `cursor.md`，并提供可直接复制的模板）。
- Antigravity：推荐作为“守门 Agent（Gatekeeper Agent）/工作流前置步骤”使用，把安全审计变成一个必须先通过的阶段（见 `antigravity.md`，并提供可复制的 Agent Prompt 模板和本地扫描脚本）。

## 你可以直接复用的文件

- 通用中文系统指令模板：`../templates/common/SECURITY_PREFLIGHT_PROMPT_CN.md`
- Cursor 规则模板：
  - `../templates/cursor/.cursorrules`
  - `../templates/cursor/.cursor/rules/security-preflight.md`
- Antigravity/通用 Gatekeeper Agent 系统提示：`../templates/antigravity/gatekeeper-agent.system.md`
- 只读扫描脚本（推荐用于 workflow step）：`../scripts/preflight_rg.sh`
