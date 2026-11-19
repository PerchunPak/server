#!/usr/bin/env bash
set -euo pipefail

repo="PerchunPak/nixos-dotfiles"
workflow="update-flake-lock.yml"
ref="main"
token_file="/home/ubuntu/configs/data/perchun-flake-lock-token.txt"

token="$(<"$token_file")"

status="$(curl -sS -o /dev/stderr -w '%{http_code}' \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$repo/actions/workflows/$workflow/dispatches" \
  -d "{\"ref\":\"$ref\"}")"

if [[ "$status" != "204" ]]; then
  echo "workflow dispatch failed with HTTP $status" >&2
  exit 1
fi
