import os
import subprocess

from libqtile import hook, layout
from libqtile.config import (
    DropDown,
    EzClick,
    EzDrag,
    EzKey,
    Group,
    Key,
    Match,
    ScratchPad,
    Screen,
)
from libqtile.lazy import lazy

BROWSER = os.getenv("BROWSER") or "xdg-open https://"
# FIX: LATER: `kitty --single-instance` cannot be used for dropdowns
# TERMINAL = os.getenv("TERMINAL") or "rofi-sensible-terminal"

FOCUS = "#54546D"
NORMAL = "#16161D"
SPECIAL = "#7E9CD8"

# FEAT: come up with a sensible dual monitor workflow
screens = [Screen()]

groups = [
    *(Group(i) for i in "123456"),
    ScratchPad(
        "scratchpad",
        dropdowns=[
            DropDown(
                "term",
                "kitty",
                on_focus_lost_hide=False,
                opacity=1.0,
                height=0.66,
                width=0.66,
                x=0.17,
                y=0.17,
            )
        ],
    ),
]

layouts = [
    layout.Columns(
        border_focus=FOCUS,
        border_normal=NORMAL,
        border_focus_stack=SPECIAL,
        border_normal_stack=NORMAL,
        border_width=2,
        grow_amount=5,
        wrap_focus_columns=False,
        wrap_focus_rows=False,
    ),
    layout.Max(
        border_focus=FOCUS,
        border_normal=NORMAL,
        border_width=2,
    ),
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
    border_focus=FOCUS,
    border_normal=NORMAL,
    border_width=2,
)

# FIX(upstream): ASAP: cannot cycle through stacks using mouse
# | https://github.com/qtile/qtile/issues/5092
mouse = [
    # Left click
    EzDrag(
        "M-1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    # Right click
    EzDrag(
        "M-3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    EzClick("M-2", lazy.window.kill()),  # Wheel click
    EzClick("M-4", lazy.layout.up()),  # Scroll up
    EzClick("M-5", lazy.layout.down()),  # Scroll down
]

keys = [
    # Switch groups
    *(
        key
        for g, k in zip(groups, "asdfwe")
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
    EzKey("M-r", lazy.spawn("rofi -show drun"), desc="Launch application"),
    EzKey("M-q", lazy.window.kill(), desc="Close window"),
    EzKey("M-<Period>", lazy.spawn("kitty --single-instance"), desc="Launch terminal"),
    EzKey("M-<Slash>", lazy.spawn(BROWSER), desc="Launch browser"),

    # Toggle dropdowns
    EzKey(
        "M-<Space>",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Dropdown terminal",
    ),

    # Navigate windows
    EzKey("M-h", lazy.layout.left(), desc="Focus left"),
    EzKey("M-j", lazy.layout.down(), desc="Focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Focus up"),
    EzKey("M-l", lazy.layout.right(), desc="Focus right"),
    EzKey("M-<Tab>", lazy.spawn("rofi -show window"), desc="Browse windows"),

    # Rearrange windows
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Shuffle left"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Shuffle down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Shuffle up"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Shuffle right"),
    EzKey("M-S-m", lazy.layout.swap_column_left(), desc="Swap columns"),

    # Resize windows
    EzKey("M-C-h", lazy.layout.grow_left(), desc="Grow left"),
    EzKey("M-C-j", lazy.layout.grow_down(), desc="Grow down"),
    EzKey("M-C-k", lazy.layout.grow_up(), desc="Grow up"),
    EzKey("M-C-l", lazy.layout.grow_right(), desc="Grow right"),
    EzKey("M-C-m", lazy.layout.normalize(), desc="Reset window sizes"),

    # Manage layouts
    EzKey("M-u", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    EzKey("M-i", lazy.layout.toggle_split(), desc="Toggle stacking"),
    EzKey("M-o", lazy.next_layout(), desc="Toggle layout"),
    EzKey("M-p", lazy.window.toggle_floating(), desc="Toggle floating"),
    EzKey("M-<Semicolon>", lazy.next_screen(), desc="Switch screen"),

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
        "<XF86MonBrightnessUp>",
        lazy.spawn("brightnessctl set +5%"),
        desc="Brightness down",
    ),
    EzKey(
        "<XF86MonBrightnessDown>",
        lazy.spawn("brightnessctl set 5%-"),
        desc="Brightness up",
    ),

    # Restart & Shutdown
    # FEAT: setup lockscreen & suspend
    EzKey("M-C-r", lazy.reload_config(), desc="Reload Qtile"),
    EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    EzKey("M-S-r", lazy.spawn("reboot"), desc="Reboot Desktop"),
    EzKey("M-S-q", lazy.spawn("shutdown now"), desc="Shutdown Desktop"),
]  # fmt: skip


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
def startup() -> None:
    # see `~/.config/systemd/user/autostart@.service`
    subprocess.run(["systemctl", "--user", "start", "autostart@qtile.target"])


@hook.subscribe.shutdown
def shutdown() -> None:
    subprocess.run(["systemctl", "--user", "stop", "autostart@qtile.target"])
