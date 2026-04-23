#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[bootstrap] %s\n' "$*" >&2
}

die() {
  log "ERROR: $*"
  exit 1
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

verify_sha256_if_requested() {
  local file="$1"
  local expected="$2"

  if [[ -z "$expected" ]]; then
    return 0
  fi

  if ! has_cmd shasum; then
    die 'shasum が見つからないためチェックサム検証できません'
  fi

  local actual
  actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  if [[ "$actual" != "$expected" ]]; then
    die "checksum mismatch expected=$expected actual=$actual"
  fi
}

usage() {
  cat <<'USAGE'
Usage:
  ops/chezmoi/bootstrap.sh [--source <dir>] [-- <chezmoi apply args...>]

Options:
  --source, -s   chezmoi source directory (default: $CHEZMOI_SOURCE_DIR or repo root)
  --help, -h     show this help

Examples:
  ./ops/chezmoi/bootstrap.sh
  ./ops/chezmoi/bootstrap.sh --source "$HOME/work/dotfiles"
  ./ops/chezmoi/bootstrap.sh --source "$PWD" -- --dry-run --verbose
USAGE
}

resolve_chezmoi() {
  if [[ -n "${CHEZMOI_BIN:-}" ]] && [[ -x "${CHEZMOI_BIN}" ]]; then
    printf '%s\n' "${CHEZMOI_BIN}"
    return 0
  fi

  if has_cmd chezmoi; then
    command -v chezmoi
    return 0
  fi

  if [[ -x "$HOME/.local/bin/chezmoi" ]]; then
    printf '%s\n' "$HOME/.local/bin/chezmoi"
    return 0
  fi

  return 1
}

install_chezmoi() {
  local -a install_args=("-b" "$HOME/.local/bin")
  local installer

  if [[ -n "${CHEZMOI_VERSION:-}" ]]; then
    install_args+=("--version" "${CHEZMOI_VERSION}")
  fi

  if ! has_cmd curl; then
    die 'curl が見つからないため chezmoi を自動導入できません'
  fi

  log 'chezmoi が見つからないため ~/.local/bin にインストールします'
  installer="$(mktemp /tmp/chezmoi-install.XXXXXX)"
  curl -fsLS get.chezmoi.io -o "$installer"
  verify_sha256_if_requested "$installer" "${CHEZMOI_INSTALLER_SHA256:-}"
  sh "$installer" -- "${install_args[@]}"
  rm -f "$installer"
}

main() {
  local script_dir
  local repo_root
  local source_dir
  local chezmoi_bin
  local -a apply_args=()

  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(cd -- "${script_dir}/../.." && pwd)"
  source_dir="${CHEZMOI_SOURCE_DIR:-$repo_root}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source|-s)
        if [[ $# -lt 2 ]] || [[ -z "${2:-}" ]]; then
          die '--source にはディレクトリを指定してください'
        fi
        source_dir="$2"
        shift 2
        ;;
      --source=*)
        source_dir="${1#*=}"
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      --)
        shift
        apply_args+=("$@")
        break
        ;;
      *)
        apply_args+=("$1")
        shift
        ;;
    esac
  done

  if [[ -z "$source_dir" ]]; then
    die 'source directory が空です'
  fi

  if [[ ! -d "$source_dir" ]]; then
    die "source directory が存在しません: $source_dir"
  fi

  source_dir="$(cd -- "$source_dir" && pwd -P)"

  if ! chezmoi_bin="$(resolve_chezmoi)"; then
    install_chezmoi
    chezmoi_bin="$(resolve_chezmoi)"
  fi

  log "chezmoi apply を実行します (source: $source_dir)"
  "${chezmoi_bin}" apply --source "$source_dir" "${apply_args[@]}"
}

main "$@"
