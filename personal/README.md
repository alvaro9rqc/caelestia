# Personal configuration

The `personal` manifest component installs the update-safe Caelestia settings
from this directory. Machine-specific desktop application bindings are kept in
`~/.config/caelestia/desktop-apps.local.json` and are not tracked.

Bind a readable alias to an installed desktop application:

```sh
caelestia-desktop bind notion
```

The command presents the installed applications through fuzzel, stores the
selected desktop file locally and reloads Hyprland. Toggles in `cli.json` only
refer to the readable alias. Run `caelestia-desktop bind notion` again after
moving the web app to another browser or browser profile.
