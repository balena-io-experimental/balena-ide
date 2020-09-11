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
    jq -n "{}" > "$FILE"
  fi
}

CODE_WORKSPACE_PATH=${CODE_WORKSPACE_PATH:-"/usr/src/projects"}
CODE_SETTINGS_PATH=${CODE_SETTINGS_PATH:-"/usr/src/settings"}
USER_SETTINGS_PATH="$CODE_SETTINGS_PATH/User"
USER_SETTINGS_FILE="$USER_SETTINGS_PATH/settings.json"
GIST_SETTINGS_PATH="$CODE_SETTINGS_PATH/gist"

# Create settings directory
mkdir -p "$USER_SETTINGS_PATH"

# Download settings if gist provided
if [[ -n CODE_SETTINGS_GIST ]]; then
  echo "Downloading VSCode settings from gist: $CODE_SETTINGS_GIST"
  rm -rf "$GIST_SETTINGS_PATH"
  git clone "$CODE_SETTINGS_GIST" "$GIST_SETTINGS_PATH"

  [[ -f "$GIST_SETTINGS_PATH/settings.json" ]] && cp "$GIST_SETTINGS_PATH/settings.json" "$USER_SETTINGS_PATH/settings.json"
  [[ -f "$GIST_SETTINGS_PATH/keybindingsMac.json" ]] && cp "$GIST_SETTINGS_PATH/keybindingsMac.json" "$USER_SETTINGS_PATH/keybindings.json"
  [[ -f "$GIST_SETTINGS_PATH/keybindings.json" ]] && cp "$GIST_SETTINGS_PATH/keybindings.json" "$USER_SETTINGS_PATH/keybindings.json"
  # TODO: snippets and extensions!
fi

# settings.json
# - AutoSave off --> impossible to use livepush without this
# - /bin/bash default --> for autocompletion
json_create_file_if_not_exist "$USER_SETTINGS_FILE"
json_add_key_if_not_exist "$USER_SETTINGS_FILE" "files.autoSave" "off"
json_add_key_if_not_exist "$USER_SETTINGS_FILE" "terminal.integrated.shell.linux" "/bin/bash"

# Start code-server
code-server "$CODE_WORKSPACE_PATH" \
  --auth none \
  --bind-addr 0.0.0.0:8080 \
  --disable-telemetry \
  --user-data-dir "$CODE_SETTINGS_PATH"
