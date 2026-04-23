#!/usr/bin/env bash
set -euo pipefail

OPTIONAL_SKIPPED=0
STATUS_FILE=''
SOURCE_DIR=''
TOOL_FILTER="${MISE_TOOL_FILTER:-}"

log() {
  printf '[mise-tools] %s\n' "$*" >&2
}

usage() {
  cat <<'USAGE'
Usage:
  ops/install/setup-mise-tools.sh [--source <dir>] [--status-file <path>] [--tools <csv>]

Options:
  --source, -s       repository source directory
  --status-file      write optional status file
  --tools            comma-separated tool filter (e.g. ruby,node,terraform)
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

should_include_tool() {
  local tool_name="$1"
  local entry
  local -a filters=()

  if [[ -z "$TOOL_FILTER" ]]; then
    return 0
  fi

  IFS=',' read -r -a filters <<< "$TOOL_FILTER"
  for entry in "${filters[@]}"; do
    entry="${entry//[[:space:]]/}"
    if [[ "$tool_name" == "$entry" ]]; then
      return 0
    fi
  done

  return 1
}

install_tool_spec() {
  local mise_bin="$1"
  local config_file="$2"
  local tool_name="$3"
  local version="$4"
  local requirement="$5"
  local fallback_csv="$6"
  local candidate
  local fallback
  local success=0
  local -a candidates=("$tool_name")
  local -a extra=()

  if [[ -n "$fallback_csv" ]]; then
    IFS=',' read -r -a extra <<< "$fallback_csv"
    for fallback in "${extra[@]}"; do
      if [[ -n "$fallback" ]]; then
        candidates+=("$fallback")
      fi
    done
  fi

  for candidate in "${candidates[@]}"; do
    log "install: ${candidate}@${version}"
    if MISE_GLOBAL_CONFIG_FILE="$config_file" "$mise_bin" -y install "${candidate}@${version}"; then
      success=1
      break
    fi
    log "warn: install failed for ${candidate}@${version}"
  done

  if [[ "$success" -eq 1 ]]; then
    return 0
  fi

  if [[ "$requirement" == 'optional' ]]; then
    log "best-effort skip: ${tool_name}@${version}"
    return 0
  fi

  skip_or_fail "required tool failed: ${tool_name}@${version}"
}

install_declared_tools() {
  local source_dir="$1"
  local mise_bin="$2"
  local config_file="$3"
  local helper_file
  local row
  local tool_name
  local version
  local requirement
  local fallback_csv
  local -a failures=()

  helper_file="$source_dir/ops/mise/tool-specs.sh"
  if [[ ! -f "$helper_file" ]]; then
    skip_or_fail "tool spec helper not found: $helper_file"
    return $?
  fi

  # shellcheck source=/dev/null
  source "$helper_file"

  while IFS= read -r row; do
    [[ -z "$row" ]] && continue

    IFS='|' read -r tool_name version requirement fallback_csv <<< "$row"

    if [[ -z "$tool_name" ]] || [[ -z "$version" ]] || [[ -z "$requirement" ]]; then
      if ! skip_or_fail "invalid tool spec: $row"; then
        failures+=("$row")
      fi
      continue
    fi

    if ! should_include_tool "$tool_name"; then
      continue
    fi

    if ! install_tool_spec \
      "$mise_bin" \
      "$config_file" \
      "$tool_name" \
      "$version" \
      "$requirement" \
      "${fallback_csv:-}"; then
      failures+=("${tool_name}@${version}")
    fi
  done < <(mise_tool_specs)

  if [[ ${#failures[@]} -gt 0 ]]; then
    log "error: failed required tool installs: ${failures[*]}"
    return 1
  fi
}

main() {
  local script_dir
  local repo_root
  local config_file
  local mise_bin

  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(cd -- "${script_dir}/../.." && pwd)"
  SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-$repo_root}"

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
      --tools)
        if [[ $# -lt 2 ]] || [[ -z "${2:-}" ]]; then
          log 'error: --tools requires a comma-separated tool list'
          exit 1
        fi
        TOOL_FILTER="$2"
        shift 2
        ;;
      --tools=*)
        TOOL_FILTER="${1#*=}"
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

  if [[ -z "$SOURCE_DIR" ]]; then
    log 'error: source directory is empty'
    exit 1
  fi
  if [[ ! -d "$SOURCE_DIR" ]]; then
    log "error: source directory does not exist: $SOURCE_DIR"
    exit 1
  fi
  SOURCE_DIR="$(cd -- "$SOURCE_DIR" && pwd -P)"

  config_file="$SOURCE_DIR/.config/mise/config.toml"
  if [[ ! -f "$config_file" ]]; then
    skip_or_fail "mise global config file not found: $config_file"
    write_status_file
    return $?
  fi

  if ! mise_bin="$(resolve_mise_bin)"; then
    skip_or_fail 'mise command is not available; run setup-mise.sh first'
    write_status_file
    return $?
  fi

  install_declared_tools "$SOURCE_DIR" "$mise_bin" "$config_file"
  write_status_file
}

main "$@"
