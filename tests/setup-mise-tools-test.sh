#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP_SCRIPT="$REPO_ROOT/ops/install/setup-mise-tools.sh"
TEMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEMP_ROOT"' EXIT

fail() {
  printf 'not ok - %s\n' "$*" >&2
  exit 1
}

assert_log_contains() {
  local expected="$1"
  grep -Fqx -- "$expected" "$FAKE_MISE_LOG" || fail "missing log entry: $expected"
}

make_fixture() {
  local name="$1"
  local fixture="$TEMP_ROOT/$name"

  mkdir -p "$fixture/ops/mise"
  cp "$REPO_ROOT/ops/mise/tool-specs.sh" "$fixture/ops/mise/tool-specs.sh"
  (cd -- "$fixture" && pwd -P)
}

mkdir -p "$TEMP_ROOT/bin"
cat > "$TEMP_ROOT/bin/mise" <<'FAKE_MISE'
#!/usr/bin/env bash
set -euo pipefail
printf '%s|%s\n' "${MISE_GLOBAL_CONFIG_FILE:-}" "$*" >> "$FAKE_MISE_LOG"
if [[ "$*" == '-y install apm@0.29.0' ]]; then
  exit 1
fi
FAKE_MISE
chmod +x "$TEMP_ROOT/bin/mise"

export PATH="$TEMP_ROOT/bin:/usr/bin:/bin"
export FAKE_MISE_LOG="$TEMP_ROOT/mise.log"
unset CHEZMOI_OPTIONAL_SETUP

fixture="$(make_fixture dot-config)"
mkdir -p "$fixture/dot_config/mise"
: > "$fixture/dot_config/mise/config.toml"
: > "$FAKE_MISE_LOG"
"$SETUP_SCRIPT" --source "$fixture" --tools node
assert_log_contains "$fixture/dot_config/mise/config.toml|-y install node@lts"
printf 'ok - resolves chezmoi dot_config path\n'

fixture="$(make_fixture legacy-config)"
mkdir -p "$fixture/.config/mise"
: > "$fixture/.config/mise/config.toml"
: > "$FAKE_MISE_LOG"
"$SETUP_SCRIPT" --source "$fixture" --tools node
assert_log_contains "$fixture/.config/mise/config.toml|-y install node@lts"
printf 'ok - preserves legacy .config fallback\n'

fixture="$(make_fixture missing-config)"
if "$SETUP_SCRIPT" --source "$fixture" --tools node >/dev/null 2>&1; then
  fail 'missing config unexpectedly succeeded in required mode'
fi
printf 'ok - missing config fails in required mode\n'

fixture="$(make_fixture apm-fallback)"
mkdir -p "$fixture/dot_config/mise"
: > "$fixture/dot_config/mise/config.toml"
: > "$FAKE_MISE_LOG"
"$SETUP_SCRIPT" --source "$fixture" --tools apm
assert_log_contains "$fixture/dot_config/mise/config.toml|-y install apm@0.29.0"
assert_log_contains "$fixture/dot_config/mise/config.toml|-y install github:microsoft/apm@0.29.0"
printf 'ok - installs APM through the GitHub backend fallback\n'
