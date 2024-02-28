#!/bin/bash
set -e

if [ ! -d "scripts/auto-update/.venv" ]; then
  echo creating venv...
  python3 -m venv scripts/auto-update/.venv
fi

scripts/auto-update/.venv/bin/python3 -m ensurepip
scripts/auto-update/.venv/bin/python3 -m pip install -Ur scripts/auto-update/requirements.txt

sudo cp scripts/auto-update/systemd.service /etc/systemd/system/auto-update.service
sudo sed -i "s|{{PWD}}|$(pwd)|g" /etc/systemd/system/auto-update.service
sudo sed -i "s|{{USER}}|$USER|g" /etc/systemd/system/auto-update.service
sudo systemctl enable --now auto-update.service
