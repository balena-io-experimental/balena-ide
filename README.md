# balena-ide

Turn your balenaOS device into a development machine.

Features:
- `code-server`, the open source core of VS Code running in your browser
- `balena-cli`, deploy and manage your devices
- Other development tools: `git`

**Note**: Currently only works on Intel NUC devices.


## Environment variables
| Variable | Description | Default |
| ------ | ------ | ------ |
| CODE_WORKSPACE_PATH | Path to the default IDE workspace | `/usr/src/projects` |
| CODE_SETTINGS_PATH | Path to the IDE settings directory | `/usr/src/settings` |
| CODE_SETTINGS_GIST | URL to a VSCode settings backup in gist format. Currently will sync keybindings and editor settings. TODO: Extensions and snippets.<br>Can be generated with [`Settings Sync`](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync).  | --- |


