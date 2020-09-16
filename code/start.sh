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

# Paths
WORKSPACE_PATH=${WORKSPACE_PATH:-"/usr/src/projects"}
SETTINGS_PATH=${SETTINGS_PATH:-"~/"}
USER_PATH="$SETTINGS_PATH/User"
GIST_PATH="$SETTINGS_PATH/gist"

# Files
SETTINGS_FILE="$USER_PATH/settings.json"
SSH_PRIVATE_KEY=~/.ssh/id_rsa
SSH_PUBLIC_KEY=~/.ssh/id_rsa.pub

# Configure git
if [[ -n "$GIT_USER_EMAIL" && -n "$GIT_USER_NAME" ]]; then
  git config --global user.email "$GIT_USER_EMAIL"
  git config --global user.name "$GIT_USER_NAME"
  if [[ ! -f "$SSH_PRIVATE_KEY" ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f "$SSH_PRIVATE_KEY"
  fi
  echo -e "\nSSH public key, add this to your GitHub/GitLab profile:\n"
  cat "$SSH_PUBLIC_KEY"
  echo -e "\n"
else
  echo "Skipping git configuration..."
fi

# Configure balena CLI
if [[ -n "$CLI_TOKEN" ]]; then
  balena login --token "$CLI_TOKEN"
fi

# Create settings directory
mkdir -p "$USER_PATH"

# Download settings if gist provided
if [[ -n "$SETTINGS_GIST" && ! -d "$GIST_PATH" ]]; then
  echo "Downloading VSCode settings from gist: $SETTINGS_GIST"
  rm -rf "$GIST_PATH"
  git clone "$SETTINGS_GIST" "$GIST_PATH"

  echo "Installing settings and keybinds..."
  [[ -f "$GIST_PATH/settings.json" ]] && cp "$GIST_PATH/settings.json" "$USER_PATH/settings.json"
  [[ -f "$GIST_PATH/keybindingsMac.json" ]] && cp "$GIST_PATH/keybindingsMac.json" "$USER_PATH/keybindings.json"
  [[ -f "$GIST_PATH/keybindings.json" ]] && cp "$GIST_PATH/keybindings.json" "$USER_PATH/keybindings.json"
  if [[ -f "$GIST_PATH/extensions.json" ]]; then
    for extension in $(jq -r ".[] | .publisher + \".\" + .name" $GIST_PATH/extensions.json)
    do
      code-server --install-extension "$extension" --user-data-dir "$SETTINGS_PATH"
    done
  fi
  # TODO: snippets
fi

# settings.json
# - AutoSave off --> impossible to use livepush without this
# - /bin/bash default --> for autocompletion
# - keyCode dispatch to enable ctrl-z to work
json_create_file_if_not_exist "$SETTINGS_FILE"
json_add_key_if_not_exist "$SETTINGS_FILE" "files.autoSave" "off"
json_add_key_if_not_exist "$SETTINGS_FILE" "terminal.integrated.shell.linux" "/bin/bash"
json_add_key_if_not_exist "$SETTINGS_FILE" "keyboard.dispatch" "keyCode"

# Start code-server
exec code-server "$WORKSPACE_PATH" \
  --auth none \
  --bind-addr 0.0.0.0:8080 \
  --disable-telemetry \
  --user-data-dir "$SETTINGS_PATH"
