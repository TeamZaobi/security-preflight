# Cursor 集成（推荐：Project Rules）

Cursor 最适合用“项目规则（Project Rules）”落地：把安全门禁写进项目，任何人用 Cursor 在该项目里尝试安装依赖、运行未知脚本、或引入外部代码时，都会先被规则引导执行隔离审计。

> 目标：把 `security-preflight` 变成“默认先过海关”的工作流，而不是靠记忆。

## 方案 A（推荐）：使用 Project Rules

1) 在你的目标项目根目录创建/更新 Cursor 规则文件（不同版本命名可能不同）：
- `./.cursorrules`（旧/兼容）
- 或 `./.cursor/rules/security-preflight.md`（新规则目录）

2) 直接复制本仓库提供的模板：
- `../templates/cursor/.cursorrules`
- `../templates/cursor/.cursor/rules/security-preflight.md`

3) 在 Cursor 设置里确保启用了 Project Rules（如果你的版本提供开关）。

## 方案 B：作为团队 SOP（无规则文件）

如果你不想改项目文件，也可以把 `../templates/common/SECURITY_PREFLIGHT_PROMPT_CN.md` 粘贴到 Cursor 的自定义指令里（例如“系统提示/项目提示”之类的入口），效果等同，但可审计性/可共享性弱于方案 A。

## 推荐实践

- 永远先把外部仓库/Skill clone 到隔离目录：`~/temp_skills_quarantine/<name>`。
- 在 PASS 前禁止：
  - `npm install` / `pnpm install` / `yarn`
  - `pip install` / `poetry install`
  - 任何 build/test/run 脚本（可能触发 install hooks、postinstall、setup.py 等）
- 需要跑扫描时，用本仓库脚本：`../scripts/preflight_rg.sh ~/temp_skills_quarantine/<name>`（只读扫描，不执行目标代码）。

