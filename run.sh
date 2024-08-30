#!/bin/bash
set -e

if [ -z "$1" ]; then
	echo "No argument supplied"
	exit 1
fi

python3 -m scripts.mkdirs
python3 -m scripts.move_env_files

if [[ $1 == "auto-update" ]]; then
  chmod +x ./scripts/auto-update/install.sh
  ./scripts/auto-update/install.sh
  exit 0
fi

function run_file {
	PWD="$(pwd)" docker compose -f "$1" up -d
}

for FILE in projects/*; do
	if [[ $1 == "all" ]]; then
		run_file "$FILE"
		continue
	fi

	if [[ $1 != "$FILE" ]]; then
		continue
	fi

	run_file "$FILE"
	break
done
