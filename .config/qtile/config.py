# pyright: reportPrivateImportUsage=false
# FIX(upstream): explicitly re-export symbols
# | https://github.com/qtile/qtile/pull/5023
# | ^ has been merged, will have to wait for the new release

import subprocess

from libqtile import hook, layout
from libqtile.config import EzClick, EzDrag, EzKey, Group, Key, Match, Mouse, Screen
from libqtile.lazy import lazy

mod = "mod4"

TERMINAL = "kitty"
BROWSER = "vivaldi"

FOCUS = "#54546d"
NORMAL = "#16161d"
SPECIAL = "#7e9cd8"

screens = [Screen()]  # FEAT: come up with a sensible dual monitor workflow
groups = [Group(i) for i in "asdf1234"]  # FEAT: add scratchpad groups

# FIX: fitting border colors for the kanagawa theme.
layouts = [
    layout.Columns(
        border_focus=FOCUS,
        border_normal=NORMAL,
        border_focus_stack=SPECIAL,
        border_normal_stack=NORMAL,
        border_width=1,
        grow_amount=5,
    ),
    layout.Max(),
]

floating_layout = layout.Floating(
    # NOTE: use `xprop` to see the wm class and name of an X client.
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="ssh-askpass"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="pinentry-gtk"),
        Match(title="pinentry"),
    ],
    border_focus=SPECIAL,
    border_normal=NORMAL,
)

mouse: list[Mouse] = [
    EzClick("M-1", lazy.window.bring_to_front()),
    EzDrag(
        "M-2",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    EzDrag(
        "M-3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
]

keys = [
    # Launch programs
    EzKey("M-z", lazy.spawn(TERMINAL), desc="Launch terminal"),
    EzKey("M-x", lazy.spawn("rofi -show drun"), desc="Launch application"),
    EzKey("M-c", lazy.spawn("rofi -show run"), desc="Launch command"),
    EzKey("M-v", lazy.spawn(BROWSER), desc="Launch browser"),

    # Switch windows
    EzKey("M-h", lazy.layout.left(), desc="Focus left"),
    EzKey("M-j", lazy.layout.down(), desc="Focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Focus up"),
    EzKey("M-l", lazy.layout.right(), desc="Focus right"),
    EzKey("M-<Space>", lazy.spawn("rofi -show window"), desc="Browse windows"),

    # Rearrange windows
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move left"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move up"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move right"),
    EzKey("M-A-h", lazy.layout.swap_column_left(), desc="Swap column left"),
    EzKey("M-A-l", lazy.layout.swap_column_right(), desc="Swap column right"),

    # Resize windows
    EzKey("M-C-h", lazy.layout.grow_left(), desc="Grow left"),
    EzKey("M-C-j", lazy.layout.grow_down(), desc="Grow down"),
    EzKey("M-C-k", lazy.layout.grow_up(), desc="Grow up"),
    EzKey("M-C-l", lazy.layout.grow_right(), desc="Grow right"),
    EzKey("M-<Equal>", lazy.layout.normalize(), desc="Reset window sizes"),

    # Manage layouts
    EzKey("M-u", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    EzKey("M-i", lazy.layout.toggle_split(), desc="Toggle stacking"),
    EzKey("M-o", lazy.next_layout(), desc="Toggle layout"),
    EzKey("M-p", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Thy end is now
    EzKey("M-w", lazy.window.kill(), desc="Close window"),

    # Manage desktop
    # FEAT: setup lockscreen & suspend
    EzKey("M-C-r", lazy.reload_config(), desc="Reload Qtile"),
    EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    EzKey("M-S-r", lazy.spawn("reboot"), desc="Reboot Desktop"),
    EzKey("M-S-q", lazy.spawn("shutdown now"), desc="Shutdown Desktop"),
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
focus_on_window_activation = "smart"
follow_mouse_focus = True
reconfigure_screens = True


@hook.subscribe.startup
def autostart() -> None:
    # see `~/.config/systemd/user/autostart@.service`
    subprocess.run(["systemctl", "--user", "start", "autostart@qtile.target"])
    subprocess.run(["nitrogen", "--restore"])
