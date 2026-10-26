#!/usr/bin/env python3
"""Control the official Toggl CLI with Zenity dialogs.

Run with --help for options and examples; see toggl-menu.md for setup.
Dry runs still query Toggl and show dialogs, but skip timer changes,
desktop notifications, and debug-log writes.
"""

import argparse
import json
import shlex
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

DEBUG_FILE = Path("/home/revise/dotfiles/scripts/test.log")
ICON = "/home/revise/Pictures/Saved/toggl-logo.png"
HISTORY_DAYS = 90
DEBUG = False
DRY_RUN = False


def run(*args, cancel_ok=False):
    """Run a command, optionally treating Zenity's cancellation as normal."""
    result = subprocess.run(args, capture_output=True, text=True)
    if cancel_ok and result.returncode == 1:
        return None
    result.check_returncode()
    return result.stdout.rstrip("\n")


def preview(*args):
    """Print a shell-quoted command for inspection without executing it."""
    print(f"[dry-run] {shlex.join(args)}")


def toggl(*args, mutating=False):
    """Parse official CLI JSON, previewing mutations during a dry run."""
    if DRY_RUN and mutating:
        preview("toggl", "--json", *args)
        return None
    return json.loads(run("toggl", "--json", *args))


def debug(message):
    if DEBUG and not DRY_RUN:
        with DEBUG_FILE.open("a", encoding="utf-8") as file:
            file.write(f"{message}\n")


def notify(title, message):
    command = ("notify-send", f"--icon={ICON}", title, message)
    if DRY_RUN:
        preview(*command)
    else:
        run(*command)


def list_items(resource, *args):
    page = 1
    while True:
        result = toggl(
            resource, "list", *args,
            "--page", str(page), "--per-page", "100",
        )
        batch = result["data"]
        yield from batch
        if len(batch) < result.get("per_page", 100):
            return
        page += 1


def previous_entries():
    now = datetime.now(timezone.utc)
    entries = list_items(
        "time-entries",
        "--date-from", (now - timedelta(days=HISTORY_DAYS)).isoformat(),
        "--date-to", now.isoformat(),
        "--type", "activity",
    )
    entries = [
        entry for entry in entries
        if entry.get("start")
        and not entry.get("deleted_at")
        and not entry.get("archived_at")
    ]
    return sorted(
        entries,
        key=lambda entry: datetime.fromisoformat(
            entry["start"].replace("Z", "+00:00")
        ),
        reverse=True,
    )[:5]


def entry_label(entry, projects=None):
    projects = projects or {}
    task = entry.get("task") or {}
    name = entry.get("description") or task.get("name") or "(no description)"
    project_id = entry.get("project_id") or task.get("project_id")
    project = projects.get(project_id, f"Project #{project_id}")
    if project_id is None:
        project = "No project"
    # Combo choices use pipes as separators; retain original values separately.
    return " ".join(f"{name} [{project}]".replace("|", "¦").split())


def current_entry():
    """Return the current entry, normalizing the CLI's empty-string idle response."""
    entry = toggl("time-entries", "tracking", "get-tracked-time-entry")
    if entry is None or entry == "":
        return None
    if not isinstance(entry, dict) or not entry.get("id"):
        raise ValueError(f"Unexpected current timer response: {entry!r}")
    return entry


def start_toggl():
    projects = {
        project["id"]: project["name"]
        for project in list_items("projects")
    }
    project_choices = {"No project": None}
    for project_id, name in projects.items():
        label = " ".join(name.replace("|", "¦").split())
        project_choices[f"{label} [#{project_id}]"] = project_id

    previous_choices = {"None": None}
    for number, entry in enumerate(previous_entries(), 1):
        previous_choices[f"{number}. {entry_label(entry, projects)}"] = entry

    data = run(
        "zenity", "--forms",
        "--text=Start Toggl Entry" + (" (dry run)" if DRY_RUN else ""),
        "--separator=\t",
        "--add-entry=Entry Name",
        "--add-combo=Project",
        f"--combo-values={'|'.join(project_choices)}",
        "--add-combo=Or Previous Entry",
        f"--combo-values={'|'.join(previous_choices)}",
        cancel_ok=True,
    )
    if data is None:
        return

    description, project, previous = data.split("\t", 2)
    selected = previous_choices.get(previous)
    if selected is not None:
        payload = {
            key: selected[key]
            for key in ("description", "project_id", "task_id")
            if selected.get(key) is not None
        }
    else:
        payload = {"description": description}
        project_id = project_choices.get(project)
        if project_id is not None:
            payload["project_id"] = project_id

    result = toggl(
        "time-entries", "start", "--data", json.dumps(payload), mutating=True
    )
    debug(json.dumps(result, ensure_ascii=False))
    notify("Toggl Entry Started!", entry_label(selected or payload, projects))


def stop_toggl():
    if run(
        "zenity", "--question",
        "--text=Stop Toggl Entry?" + (" (dry run)" if DRY_RUN else ""),
        cancel_ok=True,
    ) is None:
        return
    result = toggl("time-entries", "stop", "--data", "{}", mutating=True)
    debug(json.dumps(result, ensure_ascii=False))
    notify("Toggl Entry Stopped!", entry_label(result) if result else "Timer stopped.")


def current_status():
    entry = current_entry()
    notify("Toggl Status", entry_label(entry) if entry else "No timer running.")


def main(argv=None):
    global DEBUG, DRY_RUN
    parser = argparse.ArgumentParser(
        description=(
            "Start or stop the active Toggl timer using Zenity dialogs.\n"
            "Uses the official @togglhq/cli for Toggl 2.0 and its active workspace."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""Examples:
  %(prog)s                    Open the start/stop dialog
  %(prog)s --dry-run          Preview changes after making dialog selections
  %(prog)s --status           Show the current timer in a notification
  %(prog)s --status --dry-run Print the notification instead of sending it
  %(prog)s --debug            Toggle the timer and append debug information
  %(prog)s --clean --dry-run  Preview clearing the log without changing it
  %(prog)s --test             Print recent entries without toggling the timer

Dry runs still make read-only Toggl requests and show Zenity dialogs.
They skip timer changes, notifications, and all debug-log writes.
Cancel a dialog to exit without changing the timer.

Requires Python 3.8+, toggl (@togglhq/cli), zenity, and notify-send.
Authenticate first with: toggl auth
History: five most recent activity entries from the last {HISTORY_DAYS} days.
Debug log: {DEBUG_FILE}
More documentation: toggl-menu.md""",
    )
    parser.add_argument(
        "-n", "--dry-run", action="store_true",
        help=(
            "print planned changes without changing timers, sending notifications, "
            "or writing logs"
        ),
    )
    parser.add_argument(
        "-d", "--debug", action="store_true",
        help="append timer information to the debug log (ignored during dry runs)",
    )
    actions = parser.add_mutually_exclusive_group()
    actions.add_argument(
        "-s", "--status", action="store_true",
        help="show the current timer in a desktop notification, then exit",
    )
    actions.add_argument(
        "-c", "--clean", action="store_true",
        help="clear the debug log and exit without contacting Toggl",
    )
    actions.add_argument(
        "-t", "--test", action="store_true",
        help="print recent entries as pipe-separated choices and exit without toggling",
    )
    args = parser.parse_args(argv)
    DEBUG = args.debug
    DRY_RUN = args.dry_run

    if args.clean:
        if DRY_RUN:
            print(f"[dry-run] Would clear debug log: {DEBUG_FILE}")
        else:
            DEBUG_FILE.write_text("", encoding="utf-8")
        return 0
    if args.status:
        current_status()
        return 0
    if args.test:
        print("|".join(["None", *map(entry_label, previous_entries())]))
        return 0

    entry = current_entry()
    debug(json.dumps(entry, ensure_ascii=False))
    if entry is None:
        start_toggl()
    else:
        stop_toggl()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        message = getattr(error, "stderr", None) or str(error)
        print(f"Error: {message.strip()}", file=sys.stderr)
        sys.exit(1)
