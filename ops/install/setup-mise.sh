#!/usr/bin/env bash
set -euo pipefail

OPTIONAL_SKIPPED=0
STATUS_FILE=''
SOURCE_DIR=''

log() {
  printf '[mise-install] %s\n' "$*" >&2
}

usage() {
  cat <<'USAGE'
Usage:
  ops/install/setup-mise.sh [--source <dir>] [--status-file <path>]

Options:
  --source, -s       repository source directory (for diagnostics only)
  --status-file      write optional status file
  --help, -h         show this help
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
    skip_or_fail 'shasum is required for checksum verification but was not found'
    return $?
  fi

  local actual
  actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  if [[ "$actual" != "$expected" ]]; then
    log "error: checksum mismatch expected=$expected actual=$actual"
    return 1
  fi
}

write_status_file() {
  if [[ -z "$STATUS_FILE" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$STATUS_FILE")"
  printf 'optional_skipped=%s\n' "$OPTIONAL_SKIPPED" > "$STATUS_FILE"
}

resolve_mise_bin() {
  local candidate

  if has_cmd mise; then
    command -v mise
    return 0
  fi

  for candidate in \
    "$HOME/.local/bin/mise" \
    "/opt/homebrew/bin/mise" \
    "/usr/local/bin/mise"; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

install_with_brew() {
  if ! has_cmd brew; then
    return 1
  fi

  if brew list --formula mise >/dev/null 2>&1; then
    log 'skip: mise is already installed via brew'
    return 0
  fi

  if ! brew info mise >/dev/null 2>&1; then
    log 'warn: brew formula "mise" not found; will try installer script'
    return 1
  fi

  log 'installing mise with brew'
  if ! brew install mise; then
    log 'warn: brew install mise failed; will try installer script'
    return 1
  fi

  return 0
}

install_with_official_script() {
  local installer_url
  local tmp_script

  if ! has_cmd curl; then
    skip_or_fail 'curl is required to install mise'
    return $?
  fi

  installer_url="${MISE_INSTALLER_URL:-https://mise.run}"
  tmp_script="$(mktemp "${TMPDIR:-/tmp}/mise-install-script.XXXXXX")"

  if ! curl -fsSL "$installer_url" -o "$tmp_script"; then
    rm -f "$tmp_script"
    skip_or_fail "failed to download mise installer: $installer_url"
    return $?
  fi

  if ! verify_sha256_if_requested "$tmp_script" "${MISE_INSTALLER_SHA256:-}"; then
    rm -f "$tmp_script"
    return 1
  fi

  if [[ -n "${MISE_INSTALL_PATH:-}" ]]; then
    mkdir -p "$(dirname "$MISE_INSTALL_PATH")"
  fi

  log "installing mise from $installer_url"
  if [[ -n "${MISE_INSTALL_VERSION:-}" ]]; then
    if ! MISE_VERSION="$MISE_INSTALL_VERSION" sh "$tmp_script"; then
      rm -f "$tmp_script"
      skip_or_fail "mise installer failed (version=$MISE_INSTALL_VERSION)"
      return $?
    fi
  else
    if ! sh "$tmp_script"; then
      rm -f "$tmp_script"
      skip_or_fail 'mise installer failed'
      return $?
    fi
  fi
  rm -f "$tmp_script"
}

ensure_mise_installed() {
  local os
  local bin_path

  if bin_path="$(resolve_mise_bin)"; then
    log "skip: mise already exists ($bin_path)"
    return 0
  fi

  os="$(uname -s)"
  case "$os" in
    Darwin|Linux)
      ;;
    *)
      skip_or_fail "unsupported os: $os"
      return $?
      ;;
  esac

  if [[ "$os" == 'Darwin' ]]; then
    install_with_brew || true
  fi

  if ! bin_path="$(resolve_mise_bin)"; then
    if ! install_with_official_script; then
      return $?
    fi
  fi

  if bin_path="$(resolve_mise_bin)"; then
    log "installed: mise ($bin_path)"
    return 0
  fi

  skip_or_fail 'mise installation completed but binary was not found'
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source|-s)
        if [[ $# -lt 2 ]] || [[ -z "${2:-}" ]]; then
          log 'error: --source requires a directory path'
          exit 1
        fi
        SOURCE_DIR="$2"
        shift 2
        ;;
      --source=*)
        SOURCE_DIR="${1#*=}"
        shift
        ;;
      --status-file)
        if [[ $# -lt 2 ]] || [[ -z "${2:-}" ]]; then
          log 'error: --status-file requires a file path'
          exit 1
        fi
        STATUS_FILE="$2"
        shift 2
        ;;
      --status-file=*)
        STATUS_FILE="${1#*=}"
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        log "error: unknown argument: $1"
        usage
        exit 1
        ;;
    esac
  done

  if [[ -n "$SOURCE_DIR" ]] && [[ ! -d "$SOURCE_DIR" ]]; then
    log "error: source directory does not exist: $SOURCE_DIR"
    exit 1
  fi

  ensure_mise_installed
  write_status_file
}

main "$@"
