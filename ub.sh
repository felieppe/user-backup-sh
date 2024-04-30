#!/bin/sh

# Constants
BKP=/backup/users
mkdir -p "$BKP"

# Loading users
USERS=/backup/users.txt

IFS=$"\n"
for USER in $(cat "$USERS")
do
  USER_FOLDER="/home/$USER"
  SAVE_TO="$BKP/$USER/"

  mkdir -p "$SAVE_TO"

  if [ ! -d "$USER_FOLDER" ]; then
    echo "Error: Directory $USER_FOLDER does not exist."
    exit 1
  fi

  PATHS=$(find "$USER_FOLDER" -type d ! -name ".*" -prune -o -print)
  for PATH in $PATHS
  do
    printf '%s\n' "$PATH"
    /bin/cp "$PATH" "$SAVE_TO"
  done
done
