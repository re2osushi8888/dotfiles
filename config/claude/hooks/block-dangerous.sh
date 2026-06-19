#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

[[ -z "$command" ]] && exit 0

block() {
  echo "Blocked: $1"
  exit 2
}

# 1. 破壊的な rm -rf
echo "$command" | grep -qE 'rm\s+-rf\s+(\/\s*$|\/\*|~)' && block "rm -rf on root/home is not allowed"
echo "$command" | grep -qE 'sudo\s+rm\s+-rf' && block "sudo rm -rf is not allowed"

# 2. git force push
echo "$command" | grep -qE 'git\s+push\s+.*(--force|-f)' && block "git push --force must be run manually"

# 3. リモートスクリプトのパイプ実行
echo "$command" | grep -qE '(curl|wget)[^|]*\|\s*(ba)?sh' && block "piping remote script to shell is not allowed"

# 4. terraform apply
echo "$command" | grep -qE 'terraform\s+apply' && block "terraform apply must be run manually"

exit 0
