#!/usr/bin/env bash

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
set -ex

FILE_NAME="/tmp/data_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz"

rm $FILE_NAME || true
tar -zcvf "$FILE_NAME" --exclude='*.png' "$DATA_FOLDER"

gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$GPG_KEY_1"
gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$GPG_KEY_2"
gpg --batch --trust-model always -o "$FILE_NAME.gpg" --encrypt -r "$GPG_KEY_1" -r "$GPG_KEY_2" "$FILE_NAME"

file_size=$(stat --printf="%s" "$FILE_NAME.gpg")
chunk_size=$((49*1024*1024))  # 49 megabytes

if (( file_size > chunk_size )); then
    split -b "$chunk_size" "$FILE_NAME.gpg" "$FILE_NAME.gpg.part"

    for part_file in $FILE_NAME.gpg.part*; do
        curl -F document=@"$part_file" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument?chat_id=$CHAT_ID"
    done

    rm "$FILE_NAME.gpg.part"*
else
    curl -F document=@"$FILE_NAME.gpg" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument?chat_id=$CHAT_ID"
fi

rm "$FILE_NAME" "$FILE_NAME.gpg" || true
