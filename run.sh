#!/bin/bash
set -e

if [ -z "$1" ]; then
	echo "No argument supplied"
	exit 1
fi

python ./mkdirs.py

#: Move example env files {{{

for FILE in configs/env/*; do
	tmp=${FILE:12}
	project=${tmp%.env*}
	move_to=data/$project/.env

	if [ ! -f $move_to ]; then
		echo Coping $FILE to $move_to
		cp $FILE $move_to
	fi
done

#: }}}

function run_file {
	PWD="$(pwd)" docker compose up -f $1
}

for FILE in projects/*; do
	if [[ $1 == "all" ]]; then
		for FILE in projects/*; do
			run_file $FILE
		done
		break
	fi

	if [[ $1 != $FILE ]]; then
		continue
	fi

	run_file $FILE
	break
done
