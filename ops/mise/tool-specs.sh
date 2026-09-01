#!/usr/bin/env bash
set -euo pipefail

mise_tool_specs() {
  cat <<'EOF'
ruby|latest|required|
node|lts|required|
apm|0.29.0|required|github:microsoft/apm
go|latest|required|
java|latest|required|
php|latest|required|
rust|stable|required|
erlang|latest|required|
terraform|latest|required|
flutter|stable|required|
aws-cli|latest|required|awscli
hub|latest|required|
direnv|latest|required|
protoc|latest|required|
peco|latest|required|
mas|latest|optional|
protobuf-rules-gen|latest|optional|github:firebase/protobuf-rules-gen
EOF
}
