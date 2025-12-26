# Claude Code 集成（作为固定前置 SOP）

Claude Code 场景通常不需要“技能目录”才能生效，最可靠的方式是把 `security-preflight` 作为固定的前置 SOP/系统指令：

1) 将 `../templates/common/SECURITY_PREFLIGHT_PROMPT_CN.md` 作为 Claude Code 的自定义指令/系统提示的一部分（或每次需要时手动粘贴）。
2) 约束：任何安装/运行外部代码前，必须先完成隔离审计并给出 PASS/FAIL。
3) PASS 才允许进入依赖安装与运行阶段；FAIL 则输出证据与清理命令。

