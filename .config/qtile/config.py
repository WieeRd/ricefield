# pyright: reportPrivateImportUsage=false
# FIX(upstream): explicitly re-export symbols
# | https://github.com/qtile/qtile/pull/5023
# | ^ has been merged, will have to wait for the new release

import subprocess

from libqtile import hook, layout
from libqtile.config import EzClick, EzDrag, EzKey, Group, Key, Match, Mouse, Screen
from libqtile.lazy import lazy

TERMINAL = "kitty"
BROWSER = "vivaldi"

FOCUS = "#54546d"
NORMAL = "#16161d"
SPECIAL = "#7e9cd8"

# FEAT: come up with a sensible dual monitor workflow
screens = [Screen()]

# FEAT: utilize scratchpads
groups = [Group(i) for i in "ABCD1234"]  

layouts = [
    layout.Columns(
        border_focus=FOCUS,
        border_normal=NORMAL,
        border_focus_stack=SPECIAL,
        border_normal_stack=NORMAL,
        border_width=2,
        grow_amount=5,
    ),
    layout.Max(),
]

floating_layout = layout.Floating(
    # NOTE: use `xprop` to see the wm class and name of an X client.
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="flameshot"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="pinentry-gtk"),
        Match(wm_class="ssh-askpass"),
        Match(title="pinentry"),
    ],
    border_focus=SPECIAL,
    border_normal=NORMAL,
)

mouse: list[Mouse] = [
    EzDrag(
        "M-1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    EzDrag(
        "M-3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    EzClick("M-2", lazy.window.bring_to_front()),
]

keys: list[Key] = [
    # Switch groups
    *(
        key
        for g, k in zip(groups, "asdf1234")
        for key in (
            Key(
                ["mod4"],
                k,
                lazy.group[g.name].toscreen(),
                desc=f"Group {g.name}",
            ),
            Key(
                ["mod4", "shift"],
                k,
                lazy.window.togroup(g.name, switch_group=True),
                desc=f"Move window to group {g.name}",
            ),
        )
    ),

    # Launch programs
    EzKey("M-z", lazy.spawn(TERMINAL), desc="Launch terminal"),
    EzKey("M-x", lazy.spawn("rofi -show drun"), desc="Launch application"),
    EzKey("M-c", lazy.spawn("rofi -show run"), desc="Launch command"),
    EzKey("M-v", lazy.spawn(BROWSER), desc="Launch browser"),
    EzKey("M-w", lazy.window.kill(), desc="Close window"),

    # Switch windows
    EzKey("M-h", lazy.layout.left(), desc="Focus left"),
    EzKey("M-j", lazy.layout.down(), desc="Focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Focus up"),
    EzKey("M-l", lazy.layout.right(), desc="Focus right"),
    EzKey("M-<Semicolon>", lazy.spawn("rofi -show window"), desc="Browse windows"),

    # Rearrange windows
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Shuffle left"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Shuffle down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Shuffle up"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Shuffle right"),
    EzKey("M-S-<Semicolon>", lazy.layout.swap_column_left(), desc="Swap columns"),

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

    # Manage desktop
    EzKey("M-C-r", lazy.reload_config(), desc="Reload Qtile"),
    EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    EzKey("M-S-r", lazy.spawn("reboot"), desc="Reboot Desktop"),
    EzKey("M-S-q", lazy.spawn("shutdown now"), desc="Shutdown Desktop"),

    # Take screenshots
    EzKey("M-g", lazy.spawn("flameshot gui"), desc="Capture area"),
    EzKey("M-b", lazy.spawn("flameshot full --clipboard"), desc="Capture screen"),

    # Adjust volume
    EzKey(
        "<XF86AudioRaiseVolume>",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Volume up",
    ),
    EzKey(
        "<XF86AudioLowerVolume>",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Volume down",
    ),
    EzKey(
        "<XF86AudioMute>",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Mute/Unmute",
    ),

    # Adjust brightness
    EzKey(
        "<XF86KbdBrightnessUp>",
        lazy.spawn("brightnessctl set 5%-"),
        desc="Brightness up",
    ),
    EzKey(
        "<XF86KbdBrightnessDown>",
        lazy.spawn("brightnessctl set +5%"),
        desc="Brightness down",
    ),

    # FEAT: setup lockscreen & suspend
]

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

# FEAT: stop & restart dependent units with PartOf=
