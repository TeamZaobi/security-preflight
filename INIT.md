# 初始化（新工作区）

本仓库可以在不同工具中以不同形态使用：

- **Codex**：作为 Skill（建议把本仓库链接到 `~/.codex/skills/`）。
- **Claude Code**：作为“固定前置安全检查 SOP”提示词。
- **Cursor**：作为 Project Rules（把规则文件放进你的项目仓库）。
- **Antigravity**：作为 Gatekeeper Agent / 工作流前置关卡（先审后跑）。

下面提供一套“开箱即用”的初始化方式（含脚本），让你只维护当前目录这一份代码。

## 0) 前置要求

- macOS/Linux：`bash`
- 推荐安装：`rg`（ripgrep）。如果没有，扫描脚本会退化使用 `grep`。

## 1) （可选）把本仓库安装到 Codex Skills 目录（软链接）

执行：

```bash
bash scripts/init.sh --codex
```

效果：
- 创建 `~/.codex/skills/security-preflight` 软链接指向本仓库目录
- 以后你只需要更新本仓库，Codex 侧自动生效（无需重复拷贝）

如需覆盖已有同名目录：

```bash
bash scripts/init.sh --codex --force
```

## 2) （可选）给某个项目安装 Cursor Project Rules

将模板复制到你的项目目录（例如 `~/code/myproject`）：

```bash
bash scripts/init.sh --cursor "$HOME/code/myproject"
```

会写入（若已存在默认不覆盖，除非 `--force`）：
- `<project>/.cursorrules`
- `<project>/.cursor/rules/security-preflight.md`

## 3) （可选）Antigravity：创建 Gatekeeper Agent（手动一步到位）

在 Antigravity 里新增一个 Agent（或 workflow step）：
- 名称：`security-preflight` 或 `gatekeeper`
- system prompt：复制 `templates/antigravity/gatekeeper-agent.system.md` 的内容

让主 Agent 的流程变成：先调用 gatekeeper 产出 PASS/FAIL，再决定是否安装/运行。

## 4) 验证（建议）

对任意隔离目录跑一次只读扫描：

```bash
bash scripts/preflight_rg.sh "$HOME/temp_skills_quarantine/<name>"
```

更多说明见：
- `integrations/README.md`
- `integrations/cursor.md`
- `integrations/antigravity.md`
