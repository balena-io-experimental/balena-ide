# balena-ide

Turn your balenaOS device into a fully featured development machine.

Features:
- `code-server`: access VS Code in your browser
- `balena-cli`: deploy and manage your devices from the comforts of the IDE's terminal
- `git`: easy integration with GitHub/GitLab

## Installation

### Deploy as an application to balenaCloud

You can deploy this project to a new balenaCloud application in one click using the button below:
[![](https://balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-playground/balena-ide)

Once deployed to your device, the IDE can be accessed by visiting `http://<DEVICE_IP>:80`.

### Deploy as a system service

Run the following script in the hostOS to install the IDE as a system service:

```bash
curl --silent https://raw.githubusercontent.com/balena-io-playground/balena-ide/master/service/install.sh | sh
```

## Configuration
### VS Code settings

[code-server](https://github.com/cdr/code-server) runs the open source core of VS Code and allows you to access it in the browser. The main difference with VS Code is the extensions marketplace (read more [here](https://github.com/cdr/code-server/blob/v3.5.0/doc/FAQ.md#differences-compared-to-vs-code)). `code-server` runs it's own open source marketplace where you can find almost all VS Code extensions, and even [request](https://github.com/cdr/code-server/blob/v3.5.0/doc/FAQ.md#how-can-i-request-a-missing-extension) missing ones. 

You can reuse your VS Code settings (settings, keybinds and extensions) by providing a link to a gist with your settings backup. The gist can be generated with the popular [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension. Note that this extension works in `code-server` but it will error out if there are other extensions that are not available. Use `SETTINGS_GIST` to set the URL to the gist backup.

### Git

Git can be configured for you if you provide your email and name. The startup script will configure git to use your information and generate an SSH key pair. The public key will be printed in the console so you can add it to your GitHub/GitLab account. Use `GIT_USER_NAME` and `GIT_USER_EMAIL` to configure your account.

### Balena

Balena CLI can also be preconfigured with an access token. Use `CLI_TOKEN` to provide a balena access token. Note that web authentication currently doesn't work so this is the next best alternative.


## Supported platforms

Currently this project only runs in x86 based systems, we recommend using an Intel NUC or the UP Board.

## Environment variables
| Variable | Description | Default |
| ------ | ------ | ------ |
| WORKSPACE_PATH | Path to the default IDE workspace | `/usr/src/projects` |
| SETTINGS_PATH | Path to the IDE settings directory | `/root` |
| PORT          | Set the port the IDE runs over. Remember to also map the port correctly in your `docker-compose.yml` file as well.| '80' |
| PASSWORD | To enable authentication and set the password to use the IDE | auth disabled |
| SETTINGS_GIST | URL to a VSCode settings backup in gist format. <br>Can be generated with [`Settings Sync`](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync).  | --- |
| GIT_USER_NAME | Git user name as seen in `git config user.name`  | --- |
| GIT_USER_EMAIL | Git user name as seen in `git config user.email`  | --- |
| CLI_TOKEN | Balena CLI [access token](https://www.balena.io/docs/learn/manage/account/#access-tokens) | --- |
