#!/bin/bash

# JSON helpers
function json_add_key_if_not_exist() {
  local FILE="$1"
  local KEY="$2"
  local VALUE="$3"
  EXISTS=$(cat "$FILE" | grep "$KEY")

  if [[ -z "$EXISTS" ]]; then
    JQ_QUERY='. + {"'$KEY'": "'$VALUE'"}'
    echo "$(jq "$JQ_QUERY" "$FILE")" > "$FILE"
  fi
}

function json_create_file_if_not_exist() {
  local FILE="$1"
  if [[ ! -f "$FILE" ]]; then
    mkdir -p $(dirname "$FILE")
    jq -n "{}" > "$FILE"
  fi
}

CODE_WORKSPACE=${CODE_WORKSPACE:-"/usr/src/projects"}
CODE_SETTINGS=${CODE_SETTINGS:-"/usr/src/settings"}
SETTINGS_FILE="$CODE_SETTINGS/User/settings.json"

# AutoSave off --> impossible to use livepush without this
# bash terminal --> for autocompletion
json_create_file_if_not_exist "$SETTINGS_FILE"
json_add_key_if_not_exist "$SETTINGS_FILE" "files.autoSave" "off"
json_add_key_if_not_exist "$SETTINGS_FILE" "terminal.integrated.shell.linux" "/bin/bash"

# Start code-server
code-server "$CODE_WORKSPACE" \
  --auth none \
  --bind-addr 0.0.0.0:8080 \
  --disable-telemetry \
  --user-data-dir "$CODE_SETTINGS"
