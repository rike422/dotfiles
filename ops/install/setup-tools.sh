#!/usr/bin/env bash
set -euo pipefail

OPTIONAL_SKIPPED=0

log() {
  printf '[tools] %s\n' "$*" >&2
}

usage() {
  cat <<'USAGE'
Usage:
  ops/install/setup-tools.sh [--source <dir>]

Options:
  --source, -s   repository source directory (default: $CHEZMOI_SOURCE_DIR or script-relative root)
  --help, -h     show this help
USAGE
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

optional_mode_enabled() {
  case "${CHEZMOI_OPTIONAL_SETUP:-0}" in
    1|true|TRUE|yes|YES)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

skip_or_fail() {
  local reason="$1"
  if optional_mode_enabled; then
    OPTIONAL_SKIPPED=1
    log "optional-skip: $reason (CHEZMOI_OPTIONAL_SETUP=1)"
    return 0
  fi

  log "error: $reason"
  return 1
}

verify_sha256_if_requested() {
  local file="$1"
  local expected="$2"

  if [[ -z "$expected" ]]; then
    return 0
  fi

  if ! has_cmd shasum; then
    skip_or_fail 'shasum が見つからないためチェックサム検証できません'
    return $?
  fi

  local actual
  actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  if [[ "$actual" != "$expected" ]]; then
    log "error: checksum mismatch expected=$expected actual=$actual"
    return 1
  fi
}

link_pure_scripts() {
  local source_dir="$1"
  local target_bin="$2"
  local -a scripts=(
    color
    check-externals
    diff-highlight
    ghbin
    github_latest_release.sh
    ike-scan.sh
  )
  local script

  for script in "${scripts[@]}"; do
    local src_path="$source_dir/tools/scripts/$script"
    local dst_path="$target_bin/$script"

    if [[ ! -f "$src_path" ]]; then
      skip_or_fail "純粋スクリプトが見つかりません: $src_path"
      return $?
    fi

    chmod +x "$src_path"
    ln -sfn "$src_path" "$dst_path"
    log "linked: $dst_path -> $src_path"
  done
}

install_gibo_binary() {
  local dst_path="$1"
  local os
  local arch
  local release_json
  local tag
  local archive_name
  local archive_url
  local tmp_archive
  local tmp_dir

  if [[ -x "$dst_path" ]]; then
    log "skip: gibo は既に存在します ($dst_path)"
    return 0
  fi

  if optional_mode_enabled; then
    skip_or_fail 'gibo の生成をスキップします'
    return $?
  fi

  if ! has_cmd curl; then
    skip_or_fail 'curl が見つからないため gibo を生成できません'
    return $?
  fi
  if ! has_cmd tar; then
    skip_or_fail 'tar が見つからないため gibo を生成できません'
    return $?
  fi

  case "$(uname -s)" in
    Darwin) os='Darwin' ;;
    Linux) os='Linux' ;;
    *)
      skip_or_fail "gibo の生成対象外 OS です: $(uname -s)"
      return $?
      ;;
  esac

  case "$(uname -m)" in
    arm64|aarch64) arch='arm64' ;;
    x86_64|amd64) arch='x86_64' ;;
    i386|i686) arch='i386' ;;
    *)
      skip_or_fail "gibo の生成対象外アーキテクチャです: $(uname -m)"
      return $?
      ;;
  esac

  release_json="$(curl -fsSL https://api.github.com/repos/simonwhitaker/gibo/releases/latest)"
  tag="$(printf '%s\n' "$release_json" | awk -F'"' '/"tag_name":/ {print $4; exit}')"
  if [[ -z "$tag" ]]; then
    skip_or_fail 'gibo の最新リリース取得に失敗しました'
    return $?
  fi

  archive_name="gibo_${os}_${arch}.tar.gz"
  archive_url="${GIBO_BINARY_URL:-https://github.com/simonwhitaker/gibo/releases/download/${tag}/${archive_name}}"
  tmp_archive="$(mktemp "${dst_path}.archive.XXXXXX")"
  tmp_dir="$(mktemp -d "${dst_path}.extract.XXXXXX")"

  if ! curl -fsSL "$archive_url" -o "$tmp_archive"; then
    rm -f "$tmp_archive"
    rm -rf "$tmp_dir"
    skip_or_fail "gibo のダウンロードに失敗しました: $archive_url"
    return $?
  fi

  verify_sha256_if_requested "$tmp_archive" "${GIBO_SHA256:-}"

  if ! tar -xzf "$tmp_archive" -C "$tmp_dir"; then
    rm -f "$tmp_archive"
    rm -rf "$tmp_dir"
    skip_or_fail 'gibo アーカイブ展開に失敗しました'
    return $?
  fi

  if [[ ! -f "$tmp_dir/gibo" ]]; then
    rm -f "$tmp_archive"
    rm -rf "$tmp_dir"
    skip_or_fail 'gibo バイナリがアーカイブ内に見つかりません'
    return $?
  fi

  chmod +x "$tmp_dir/gibo"
  mv "$tmp_dir/gibo" "$dst_path"
  rm -f "$tmp_archive"
  rm -rf "$tmp_dir"
  log "generated: gibo ($dst_path) from $archive_url"
}

main() {
  local script_dir
  local repo_root
  local source_dir
  local target_bin

  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(cd -- "${script_dir}/../.." && pwd)"
  source_dir="${CHEZMOI_SOURCE_DIR:-$repo_root}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source|-s)
        if [[ $# -lt 2 ]] || [[ -z "${2:-}" ]]; then
          log 'error: --source にはディレクトリを指定してください'
          exit 1
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
      *)
        log "error: 未知の引数です: $1"
        usage
        exit 1
        ;;
    esac
  done

  if [[ -z "$source_dir" ]]; then
    log 'error: source directory が空です'
    exit 1
  fi
  if [[ ! -d "$source_dir" ]]; then
    log "error: source directory が存在しません: $source_dir"
    exit 1
  fi

  source_dir="$(cd -- "$source_dir" && pwd -P)"
  target_bin="${XDG_BIN_HOME:-$HOME/.local/bin}"

  mkdir -p "$target_bin"
  link_pure_scripts "$source_dir" "$target_bin"

  install_gibo_binary "$target_bin/gibo"

  if [[ "$OPTIONAL_SKIPPED" -eq 1 ]]; then
    log 'optional-skip が発生しました'
  fi
}

main "$@"
