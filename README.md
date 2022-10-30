# Gilbert

## Slack application configuration

Create a Slack app.

Copy the file `.env.example` and name it `.env`.
Copy the values of the Client ID, Client Secret and Signing Secret in the `.env` file.
Copy the bot user OAuth token from section `Install App` inside the `.env` file.

### Features

#### Interactivity & Shortcuts

Enable the `interactivity` toggle.

Fill the value of the field `Request URL` (e.g. `https://<domain to use>/slack/interactive-endpoint`).

In section `Select Menus`, fill the value of the field `Options Load URL` (e.g. `https://<domain to use>/slack/options-load-endpoint`).

In section `Shortcuts`, create a new shortcut:

- Name: `Request support`
- Description: `Request support from the tech team`
- Callback ID: `request_support`

#### OAuth & Permissions

In section `Scopes`, make sure the following scopes are applied for `Bot Token Scopes`:

- `chat:write`
- `chat:write.customize`
- `commands`
- `users:read`

You will also need to add the application in the channel it is supposed to send messages using the command `/invite @<name of the bot>`.
