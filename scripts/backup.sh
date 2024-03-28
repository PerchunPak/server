#!/bin/bash

# What this script does:
#     - Packs everything in `data` into zip archive.
#     - Encrypts created archive with `gpg` for our keys.
#     - Sends encrypted archive to Telegram group.
#
# Please provide these env variables before running script:
#     - `DATA_FOLDER` - where is folder to backup?
#     - `GPG_KEY_1` - first recipient's gpg key
#     - `GPG_KEY_2` - second recipient's gpg key
#     - `BOT_TOKEN` - Telegram bot token
#     - `CHAT_ID` - Telegram chat ID to send encrypted file
#
# And do not forget to import recipients' keys:
#     gpg --keyserver keys.openpgp.org --recv-keys GPG_KEY_HERE
set -e

FILE_NAME="/tmp/data_$(date +"%Y-%m-%d_%H-%M-%S").zip.gpg"

zip -r - $DATA_FOLDER | \
	gpg --batch --trust-model always -o $FILE_NAME --encrypt -r $GPG_KEY_1 -r $GPG_KEY_2

curl -F document=@\"$FILE_NAME\" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument?chat_id=$CHAT_ID"

rm $FILE_NAME
