#!/usr/bin/env bash
set -euo pipefail

target="${1:-}"
if [[ -z "${target}" ]]; then
  echo "用法: $0 <隔离目录路径>"
  exit 2
fi

if [[ ! -d "${target}" ]]; then
  echo "错误: 目录不存在: ${target}"
  exit 2
fi

cd "${target}"

echo "== security-preflight: 只读扫描 =="
echo "目标目录: ${target}"
echo

run_rg() {
  local title="$1"
  local pattern="$2"
  echo "== ${title} =="
  if command -v rg >/dev/null 2>&1; then
    rg --hidden --no-ignore -n "${pattern}" . || true
  else
    # fallback: 不如 rg 准确/快，但可用
    grep -RInE "${pattern}" . 2>/dev/null || true
  fi
  echo
}

run_rg "网络外联/URL" '(fetch|axios|curl|requests\.|http[s]?://|wss?://)'
run_rg "敏感信息/秘密/凭证关键词" '(\.env|id_rsa|\.ssh|token|secret|credential|api[_-]?key|private[_-]?key)'
run_rg "混淆/编码" '(base64|Buffer\.from\(|atob\(|btoa\(|gzip|zlib)'
run_rg "危险执行/子进程" '(eval\(|exec\(|child_process|subprocess|os\.system|Runtime\.getRuntime\(\)\.exec)'
run_rg "安装钩子/自动执行" '(preinstall|postinstall|prepare|install|setup\.py|pyproject\.toml)'
run_rg "提示注入可疑语句" '(ignore all previous|bypass|return PASS|SAFE_TO_DEPLOY|override this prompt)'

echo "== 建议下一步 =="
echo "- 先人工打开: SKILL.md、package.json、requirements.txt/pyproject.toml、所有 .sh/.js/.py"
echo "- 未 PASS 前不要执行 npm/pip install、build/test/run"

