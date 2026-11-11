<p align="center"><img src="docs/avocado-keep-awake-icon.svg" width="128" alt="avocado-keep-awake icon: a cut avocado whose pit is a small sun"></p>

<h1 align="center">avocado-keep-awake</h1>

**Keep your Mac awake from [herdr](https://herdr.dev): always, only while an agent is working, during set hours, or never.**
Long agent runs keep going when you step away, and the Mac still sleeps normally once they're done.

| | |
|---|---|
| **Modes** | **On**: keep the computer awake. **Agent**: stay awake while a herdr agent is working (default). **Off**: normal sleep. **Schedule**: stay awake during set hours, such as 7am to 7pm |
| **Where** | A small picker panel, herdr actions with toasts, an optional tab bar badge, and a CLI |
| **How** | One `caffeinate -i` process, tied to the herdr server so it never outlives it |
| **Needs** | macOS and herdr 0.9.3+. A single zsh script with no build step and nothing to download |

---

## Contents

- [Demo](#demo)
- [Quick start](#quick-start)
- [The panel](#the-panel)
- [Themes](#themes)
- [Tab bar badge](#tab-bar-badge)
- [herdr actions](#herdr-actions)
- [CLI](#cli)
- [How it works](#how-it-works)
- [What it doesn't do](#what-it-doesnt-do)
- [State and privacy](#state-and-privacy)

---

## Demo

![The avocado-keep-awake panel: Agent mode active while an agent works, then Off, On with a number key, and back to Agent](docs/avocado-keep-awake-demo.gif)

In the recording:

1. **Agent**, the default, is active because an agent is working.
2. `↓` and `⏎` switch to **Off**, and the Mac may sleep again.
3. `1` picks **On** directly.
4. `↓` and `⏎` go back to **Agent**.

The panel is the real one, run against a stand-in herdr that reports one working agent
(`scripts/demo`). Re-record it with `vhs scripts/demo/demo.tape` (`brew install vhs`).

---

## Quick start

```sh
herdr plugin install andymartinezot/avocado-keep-awake
```

The default mode is **Agent**, so nothing else is needed. To change the mode, open herdr's action
list and pick **Keep awake: choose mode**. To open it with a key instead, add this to
`~/.config/herdr/config.toml`, using a key that is free in your setup:

```toml
[[keys.command]]
key = "prefix+shift+k"
type = "plugin_action"
command = "andymartinezot.avocado-keep-awake.open-panel"
description = "avocado-keep-awake: keep the Mac awake"
```

Then run `herdr server reload-config`. herdr reads `config.toml` only when it starts, so the key
does nothing until you reload.

---

## The panel

```
 avocado-keep-awake                 Agent · Active

 Keep computer awake
 ────────────────────────────────────────────────
    On
     Keep this computer awake continuously

 ● ▸ Agent
     Stay awake while an agent is working

    Off
     Allow normal system sleep behavior

    Schedule
     Awake 07:00–19:00, else like Agent

 ↑↓ move ⏎ select 1-4 pick e hours esc close
```

The dot marks the current mode. The header shows the mode and whether the Mac is being held awake
right now, refreshed every second.

| Key | Action |
|---|---|
| `↑` `↓` / `k` `j` | Move |
| `⏎` / `space` | Choose the highlighted mode and close |
| `1` – `4` | Choose On, Agent, Off or Schedule directly |
| `e` | Type the Schedule hours, such as `7am-7pm`, and switch to Schedule |
| `esc` / `q` | Close without changing anything |

Choosing a mode shows a toast, for example *Keep awake: Agent · Stay awake while an agent is
working · Active*.

---

## Schedule

**Schedule** keeps the Mac awake every day between two times, 07:00 to 19:00 unless you change
them. Outside those hours it works like **Agent**, so a run that is still going at 19:00 isn't cut
off.

Set the hours with `e` in the panel or from a shell:

```sh
avocado-keep-awake schedule 7am-7pm        # set the hours and switch to Schedule
avocado-keep-awake schedule 08:30-18:00
avocado-keep-awake schedule 22:00-06:00    # past midnight works too
```

Times can be `7`, `7am`, `7:30pm` or `19:00`, joined by `-` or `to`. While Schedule is on, a small
background check looks at the clock every 30 seconds and switches when the hours start or end. It
reads the wall clock, so it is right after the Mac wakes, and it exits with the herdr server or
when you pick another mode.

It keeps an awake Mac awake; it doesn't wake a sleeping one. If the Mac is already asleep at 07:00,
it stays asleep until you wake it.

---

## Themes

The panel uses the avocado palette shared with
[avocado-trope](https://github.com/andymartinezot/avocado-trope) and
[avocado-park](https://github.com/andymartinezot/avocado-park): `dracula` (default), `catppuccin`,
`tokyo-night`, `gruvbox`, `nord`, `classic` and `terminal`, with the same color for the same job in
every avocado plugin. The accent marks the title and keys, green means awake, and the muted color
marks the selected row.

It picks the first of:

1. `$AVOCADO_KEEP_AWAKE_THEME`, or `$AVOCADO_THEME` to set every avocado plugin at once
2. The theme you last switched to in avocado-trope (`t`), so both always match
3. herdr's own `[theme] name`. Names like `tokyo-night-storm` or `catppuccin-mocha` map to the
   matching theme, and light variants use `terminal`
4. `dracula`

`avocado-keep-awake theme` prints the one in use.

---

## Tab bar badge

To see at a glance that the Mac is being held awake, add a command entry to herdr's tab bar. It
prints `☕ On`, `☕ Agent` or `☕ Schedule` while the Mac is held awake, and nothing otherwise:

```toml
[ui]
tab_bar_right = [
  { type = "command", command = "~/.local/bin/avocado-keep-awake status --short", interval_seconds = 5, timeout_seconds = 2 },
]
```

Point `command` at the script: `bin/avocado-keep-awake` inside the plugin directory. You can link it
onto your `PATH` as shown, or use the full path.

---

## herdr actions

| Action | What it does |
|---|---|
| **Keep awake: choose mode** | Opens the panel |
| **Keep awake: next mode** | On → Agent → Off → Schedule → On |
| **Keep awake: On** / **Agent** / **Off** / **Schedule** | Sets that mode |

Bind any of them with `type = "plugin_action"` and the action id, for example
`andymartinezot.avocado-keep-awake.cycle`.

---

## CLI

```sh
avocado-keep-awake               # the panel
avocado-keep-awake status        # "Agent · Active", the Schedule hours and how many agents are working
avocado-keep-awake status --short
avocado-keep-awake on|agent|off  # set the mode
avocado-keep-awake schedule [7am-7pm]  # Schedule, optionally with new hours
avocado-keep-awake cycle
avocado-keep-awake sync          # bring caffeinate in line with the mode (herdr runs this for you)
avocado-keep-awake theme         # the color theme in use
```

---

## How it works

- **Awake** means one `caffeinate -i` process. It stops idle system sleep, and the display can still
  turn off. It runs with `-w <herdr server pid>`, so it exits when the herdr server does.
- **Agent mode** counts agents whose herdr status is `working`. herdr runs `sync` on startup,
  whenever an agent's status changes, and when a pane closes or exits. Agents that are `idle`,
  `done` or `blocked` waiting for you don't keep the Mac awake.
- Events can arrive in bursts, so `sync` takes a lock and there is never more than one
  `caffeinate`.

## What it doesn't do

- **Closing the lid still sleeps the Mac**, as with any `caffeinate`. Keep it open, or use an
  external display.
- It doesn't keep the display on. The screen can still lock on its normal schedule; that doesn't
  pause the agents.
- It doesn't change any system setting. Quitting herdr, or choosing **Off**, puts everything back.

## State and privacy

A few small files in the plugin's herdr config directory (`herdr plugin config-dir
andymartinezot.avocado-keep-awake`): `mode`, `window` (the Schedule hours), `caffeinate.pid`, and
`ticker.pid` while Schedule is on. No network, no other files, and
the only programs it runs are `herdr`, `caffeinate`, `ps` and `sleep`.

## License

[MIT](LICENSE)
