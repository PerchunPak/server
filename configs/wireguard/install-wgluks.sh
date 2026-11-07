#!/usr/bin/env bash
# Rebuild the salo-pc remote-LUKS-unlock WireGuard endpoint on a fresh VPS.
# Idempotent. Run as a sudo-capable user from the repo root.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SECRET_CONF="$REPO_ROOT/data/wireguard/wgluks.conf"
DEST=/etc/wireguard/wgluks.conf

if [ ! -f "$SECRET_CONF" ]; then
  echo "Missing $SECRET_CONF."
  echo "Restore it from backup, or copy configs/wireguard/wgluks.conf.template there"
  echo "and fill PrivateKey (regenerate with 'wg genkey' -- then every peer's config"
  echo "must be updated with the new server public key)."
  exit 1
fi

echo "Installing wireguard-tools..."
sudo apt-get update -qq && sudo apt-get install -y wireguard-tools

echo "Placing $DEST..."
sudo install -m600 -o root -g root "$SECRET_CONF" "$DEST"

echo "Enabling wg-quick@wgluks..."
sudo systemctl enable --now wg-quick@wgluks
sudo wg show wgluks
echo "Done. UDP 51820 must be reachable from the internet."
