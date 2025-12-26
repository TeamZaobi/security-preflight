# Codex 集成（Skill）

Codex 场景直接把本仓库作为 Skill 使用即可：

1) 将 `SKILL.md` 放入 Codex 的 skills 目录（按你的 Codex 安装路径为准）。
2) 约束：当你要求安装/运行第三方技能或代码时，优先触发并执行 `security-preflight` 的隔离审计流程。

> 也可以把 `templates/common/SECURITY_PREFLIGHT_PROMPT_CN.md` 作为补充系统指令，增强“先审后跑”的硬约束。
