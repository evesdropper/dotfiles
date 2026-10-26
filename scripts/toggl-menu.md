# Toggl menu

`toggl-menu.py` uses Zenity dialogs to start or stop a timer through the official
`@togglhq/cli` for **Toggl 2.0** workspaces. It does not use the unofficial legacy
Toggl CLI.

## Setup

Requirements:

- Python 3.8 or newer.
- Node.js 20 or newer and the official Toggl CLI.
- `zenity` for dialogs and `notify-send` for desktop notifications.
- A graphical Linux session with access to its display and notification service.

Install the official CLI and authenticate once:

```sh
npm install -g @togglhq/cli
toggl auth
```

The script uses the CLI's saved login and active workspace; it does not read the
old `auth/toggl.txt` token file. If you already export `TOGGL_API_TOKEN`, the CLI
uses that authentication instead. To select a workspace for your saved login:

```sh
toggl workspace list
toggl workspace switch <workspace-id>
```

See the [official CLI documentation](https://docs.toggl.com/toggl-mcp-and-cl).

## Usage

From `~/dotfiles/scripts`:

```sh
python3 toggl-menu.py --help
python3 toggl-menu.py
```

With no action option, the script checks the current timer:

- **No running timer:** opens a form for a description and project, or one of the
  five most recent activity entries from the last 90 days. A selected previous
  entry takes precedence over the other fields and preserves its project/task
  IDs. Leave the project empty or choose **No project** for a taskless entry
  without a project.
- **Running timer:** asks for confirmation before stopping it.

Cancelling either dialog exits without starting or stopping a timer. Successful
timer changes produce a desktop notification.

| Option | Behavior |
| --- | --- |
| `-h`, `--help` | Show options, requirements, and examples without contacting Toggl. |
| `-n`, `--dry-run` | Print planned timer and notification commands instead of executing them; do not write or clear the debug log. |
| `-d`, `--debug` | Append timer information to `test.log`; ignored during dry runs. |
| `-s`, `--status` | Show the current timer in a notification and exit without toggling it. |
| `-c`, `--clean` | Clear the debug log and exit without contacting Toggl. |
| `-t`, `--test` | Print recent entries as pipe-separated choices and exit without toggling a timer. |

`--status`, `--clean`, and `--test` are mutually exclusive. `--dry-run` and
`--debug` can be combined with any action.

## Dry runs

```sh
# Make dialog selections, then inspect the proposed commands.
python3 toggl-menu.py --dry-run

# Preview a status notification without displaying it.
python3 toggl-menu.py --status --dry-run

# Preview clearing the log, leaving its contents untouched.
python3 toggl-menu.py --clean --dry-run
```

Dry-run output is prefixed with `[dry-run]`, with commands shell-quoted for
inspection. It does **not** start or stop timers, send desktop notifications, or
append to or clear the debug log, even when combined with `--debug` or `--clean`.

Dry runs are **not offline**: status, projects, and history are still read from
Toggl, and the start/stop dialogs still appear. These calls require authentication
and network access. `--clean --dry-run` and `--help` need neither. Planned
mutating commands are printed, not submitted to the CLI for validation.

## Configuration and troubleshooting

Edit the constants at the top of `toggl-menu.py` to change:

- `ICON`: `/home/revise/Pictures/Saved/toggl-logo.png`.
- `DEBUG_FILE`: `/home/revise/dotfiles/scripts/test.log`.
- `HISTORY_DAYS`: the recent-entry lookback, currently 90 days.

Debug logs can contain descriptions and other time-entry details. They do not
include credentials. Use `--clean` to empty the log.

If authentication fails, run `toggl auth` again. If projects look wrong, check the
CLI's active workspace. If dialogs or notifications fail, confirm `zenity` and
`notify-send` are installed and run the script in a graphical session. Errors are
printed to stderr and cause a nonzero exit status.

The CLI can return JSON `""` (an empty string) when no timer is running. The
script treats this and `null` as an idle timer; other unexpected responses still
raise an error rather than risking a timer change. Inspect the current status
without changing anything using `python3 toggl-menu.py --status --dry-run`.

## Tests

From `~/dotfiles/scripts`:

```sh
python3 -m unittest discover -s tests -p 'test_toggl_menu.py'
```

Tests mock external commands; they do not contact Toggl, change live timers, show
dialogs, or send notifications.
