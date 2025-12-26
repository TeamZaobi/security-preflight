# Antigravity 集成（推荐：守门 Agent / 工作流前置关卡）

我不知道你所说的 Antigravity 具体是哪个发行版/插件形态（不同实现对“Agent/Workflow/Hook”的配置文件格式差异很大）。因此这里提供一个“最稳妥、最通用、最容易迁移”的落地方式：把 `security-preflight` 作为一个 **守门 Agent（Gatekeeper Agent）** 或工作流的 **前置关卡**。

> 目标：任何“安装依赖 / 运行下载的代码 / 启用第三方扩展/skill”的请求，都必须先由 Gatekeeper 给出 PASS，主 Agent 才能继续。

## 你应该把它当作什么？

- **不是**：一个会自动执行安装的工具。
- **是**：一个“先审后跑”的强约束 Agent（或 workflow step）。

## 最小可用集成（通用做法）

1) 在你的项目（或 Antigravity 的配置目录）里加入本仓库的 Agent Prompt 模板：
- `../templates/antigravity/gatekeeper-agent.system.md`

2) 在 Antigravity 里创建一个 Agent（或一个 workflow step），命名为：
- `security-preflight` 或 `gatekeeper`

并把上面的模板作为该 Agent 的 system prompt / instructions。

3) 让主 Agent 的工作流变成：
- **先**调用 `gatekeeper` 对“外部代码/扩展/skill”做隔离审计 → 产出 PASS/FAIL + 证据文件路径
- **再**决定是否进入安装/运行阶段

## 建议的硬门禁（强烈建议写进你的主工作流）

- 只要涉及以下行为，就必须先走 Gatekeeper：
  - `git clone` 第三方仓库（准备执行/安装/集成）
  - 任何形式的依赖安装、构建、运行（尤其在未知目录）
  - 将文件复制/移动到“自动加载目录”（插件/skills/extensions）

- Gatekeeper 在 PASS 前必须禁止：
  - `npm/pip install`、build、run
  - 任何网络访问（除非明确审计需要、并记录域名）

## 本地只读扫描脚本（可作为 workflow step）

你可以让 Antigravity 在 Gatekeeper 阶段调用一个“只读扫描脚本”（不会执行目标代码）来提高一致性：
- `../scripts/preflight_rg.sh ~/temp_skills_quarantine/<name>`

脚本输出再交给 Gatekeeper 总结为 PASS/FAIL（含可疑文件路径）。

## 为了更精确：请你补充 2 个信息

如果你告诉我下面两点，我可以把本节升级成“完全贴合你那版 Antigravity”的配置文件（例如 `.yaml/.json` 等）：
1) 你使用的 Antigravity 产品/版本链接或截图（它的 Agent/Workflow 配置入口长什么样）。
2) 它是否支持：多 Agent 编排 / pre-run hook / 自定义 system prompt / 运行本地脚本。

