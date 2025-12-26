#!/usr/bin/env bash
set -euo pipefail

force=false
do_codex=false
cursor_project=""

usage() {
  cat <<'EOF'
用法:
  bash scripts/init.sh [--codex] [--cursor <project_path>] [--force]

选项:
  --codex                将本仓库软链接到 ~/.codex/skills/security-preflight
  --cursor <project>     为指定项目写入 Cursor Project Rules 模板
  --force                覆盖/替换已存在的目标文件或目录
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --codex) do_codex=true; shift ;;
    --cursor)
      cursor_project="${2:-}"
      if [[ -z "${cursor_project}" ]]; then
        echo "错误: --cursor 需要一个项目路径" >&2
        exit 2
      fi
      shift 2
      ;;
    --force) force=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "未知参数: $1" >&2
      usage
      exit 2
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

install_codex() {
  local codex_dir="${HOME}/.codex/skills"
  local link_path="${codex_dir}/security-preflight"

  mkdir -p "${codex_dir}"

  if [[ -e "${link_path}" || -L "${link_path}" ]]; then
    if [[ "${force}" != true ]]; then
      echo "已存在: ${link_path}"
      echo "使用 --force 替换，或手动处理后重试。"
      return 0
    fi
    rm -rf "${link_path}"
  fi

  ln -s "${repo_root}" "${link_path}"
  echo "已创建软链接: ${link_path} -> ${repo_root}"
}

install_cursor_rules() {
  local project="$1"
  if [[ ! -d "${project}" ]]; then
    echo "错误: 项目目录不存在: ${project}" >&2
    exit 2
  fi

  local src_cursorrules="${repo_root}/templates/cursor/.cursorrules"
  local src_rule_md="${repo_root}/templates/cursor/.cursor/rules/security-preflight.md"

  local dst_cursorrules="${project}/.cursorrules"
  local dst_rule_dir="${project}/.cursor/rules"
  local dst_rule_md="${dst_rule_dir}/security-preflight.md"

  if [[ -e "${dst_cursorrules}" && "${force}" != true ]]; then
    echo "跳过（已存在）: ${dst_cursorrules}"
  else
    cp "${src_cursorrules}" "${dst_cursorrules}"
    echo "已写入: ${dst_cursorrules}"
  fi

  mkdir -p "${dst_rule_dir}"
  if [[ -e "${dst_rule_md}" && "${force}" != true ]]; then
    echo "跳过（已存在）: ${dst_rule_md}"
  else
    cp "${src_rule_md}" "${dst_rule_md}"
    echo "已写入: ${dst_rule_md}"
  fi
}

did_anything=false
if [[ "${do_codex}" == true ]]; then
  install_codex
  did_anything=true
fi

if [[ -n "${cursor_project}" ]]; then
  install_cursor_rules "${cursor_project}"
  did_anything=true
fi

if [[ "${did_anything}" != true ]]; then
  usage
  exit 2
fi
