# pyright: reportPrivateImportUsage=false
# FIX(upstream): explicitly re-export symbols
# | https://github.com/qtile/qtile/pull/5023
# | ^ has been merged, will have to wait for the new release

import subprocess

from libqtile import layout, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"

TERMINAL = "kitty"
BROWSER = "vivaldi"

screens = [Screen()]  # FEAT: come up with a sensible dual monitor workflow
groups = [Group(i) for i in "asdf1234"]  # FEAT: add scratchpad groups

# FIX: fitting border colors for the kanagawa theme.
layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2),
    layout.Max(),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# FIX: use EzKey helper
keys = [
    # Launch programs
    Key([mod], "z", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([mod], "x", lazy.spawn("rofi -show drun"), desc="Launch application"),
    Key([mod], "c", lazy.spawn("rofi -show run"), desc="Launch command"),
    Key([mod], "v", lazy.spawn(BROWSER), desc="Launch browser"),

    # Switch windows
    Key([mod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "space", lazy.spawn("rofi -show window"), desc="Browse windows"),

    # Rearrange windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move left"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move up"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move right"),
    Key([mod, "mod1"], "h", lazy.layout.swap_column_left(), desc="Swap column left"),
    Key([mod, "mod1"], "l", lazy.layout.swap_column_right(), desc="Swap column right"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow left"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow up"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow right"),
    Key([mod], "equal", lazy.layout.normalize(), desc="Reset window sizes"),

    # Manage layouts
    Key([mod], "u", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "i", lazy.layout.toggle_split(), desc="Toggle stacking"),
    Key([mod], "o", lazy.next_layout(), desc="Toggle layout"),
    Key([mod], "p", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Thy end is now
    Key([mod], "w", lazy.window.kill(), desc="Close window"),

    # Manage desktop
    # FEAT: setup lockscreen
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.spawn("reboot"), desc="Reboot Desktop"),
    Key([mod, "shift"], "q", lazy.spawn("shutdown now"), desc="Shutdown Desktop"),
]

# REFACTOR: use list comprehension
for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Move window to group {i.name}",
            ),
        ]
    )

wmname = "Qtile"

widget_defaults = None
extension_defaults = None

auto_fullscreen = True
auto_minimize = True

bring_front_click = False
cursor_warp = False

dgroups_app_rules = []
dgroups_key_binder = None

floats_kept_above = True
floating_layout = layout.Floating(
    # NOTE: use `xprop` to see the wm class and name of an X client.
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="ssh-askpass"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="pinentry-gtk"),
        Match(title="pinentry"),
    ]
)

focus_on_window_activation = "smart"
follow_mouse_focus = True
reconfigure_screens = True


@hook.subscribe.startup
def autostart() -> None:
    # see `~/.config/systemd/user/autostart@.service`
    subprocess.run(["systemctl", "--user", "start", "autostart@qtile.target"])
    subprocess.run(["nitrogen", "--restore"])
