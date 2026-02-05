# Copyright (c) 2012 Craig Barnes Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

# from qtile_extras.widget import StatusNotifier
import colors
from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy

# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

# import custom_widgets

mod = "mod4"  # Sets mod key to SUPER/WINDOWS
myTerm = "alacritty"  # My terminal of choice
# myTerm = "gnome-terminal"  # My terminal of choice
myBrowser = "firefox"  # My browser of choice
myFileManager = "thunar"  # My file manager
# myFileManager = "alacritty --command ranger" # My file manager
# myMail = 'mailspring --password-store="gnome-libsecret"' # My Mail
myMail = "thunderbird"  # My Mail
# screenshot = "maim -s | xclip -selection clipboard -t image/png"
screenshot = "flameshot gui --clipboard "
# Path to custom scripts
path = os.path.expanduser("~/.local/bin/scripts/")


# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
keys = [
    # Launching programs
    Key(
        [mod],
        "Backspace",
        lazy.spawn(
            'notify-send "$(fortune)" -i /usr/share/icons/Papirus-Dark/16x16/emotes/face-devilish.svg',
            shell=True,
        ),
        desc="Quote",
    ),
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    Key([mod], "d", lazy.spawn("discord"), desc="Discord"),
    Key([mod], "e", lazy.spawn(myFileManager), desc="File browser"),
    #    Key(
    #        [mod, "shift"],
    #        "p",
    #        lazy.spawn(path + "todolist", shell=True),
    #        desc="To do list",
    #    ),
    Key([mod], "m", lazy.spawn(myMail), desc="Mail client"),
    Key([mod], "v", lazy.spawn("copyq toggle"), desc="Clipboard"),
    Key([mod], "w", lazy.spawn(myBrowser), desc="Web browser"),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn(screenshot, shell=True),
        desc="Screenshot region to clipboard",
    ),
    # Rofi and prompts
    Key([mod], "p", lazy.spawn("rofi -show drun"), desc="Run Launcher"),
    Key([mod], "r", lazy.spawn("rofi -show run"), desc="Run Prompt"),
    # Key(
    #     [mod],
    #     "v",
    #     lazy.spawn(
    #         "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"
    #     ),
    #     desc="Show Clipboard",
    # ),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(path + "rofi_todo"),
        desc="todolist",
    ),
    Key(
        [mod, "shift"],
        "q",
        lazy.spawn("rofi -modi p:rofi-power-menu -show p"),
        desc="Power Menu",
    ),
    # Key([mod, "shift"], "p", lazy.spawn("rofi -show power-menu -modi power-menu:~/.local/bin/scripts/rofi-power-menu "), desc="Logout menu"), (use this if you dont' want to install the rofi-power-menu package)
    # Qtile
    # Key(
    #     [mod, "shift"],
    #     "l",
    #     lazy.spawn("i3lock -ei ~/.config/qtile/lock"),
    #     desc="Lock the screen",
    # ),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    # Key([mod, "shift"], "q", lazy.spawn("oblogout"), desc="Logout"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Caps_Lock", lazy.hide_show_bar(), desc="Toggle between layouts"),
    # Load monitor layout: I gave up on making the thing work automatically, so I'll just have a script run when a keybind is hit, the script is in ~/.local/bin/scripts/multi.sh
    # Key([mod], "o", lazy.spawn("/home/zeus/.local/bin/scripts/multi.sh", shell=True), desc="Load up monitor preset"),
    # Volumes
    # Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-"), desc="Lower Volume by 5%"),
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+"), desc="Raise Volume by 5%"),
    # Key([], "XF86AudioMute", lazy.spawn("amixer sset Master 1+ toggle"), desc="Mute/Unmute Volume"),
    # Key([], "XF86AudioMicMute", lazy.spawn("amixer set Capture toggle"), desc="Mute/Unmute Volume"),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Lower Volume by 5%",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Raise Volume by 5%",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Mute/Unmute Volume",
    ),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("amixer set Capture toggle"),
        desc="Mute/Unmute Mic",
    ),
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Treetab prompt
    Key(
        [mod, "shift"],
        "a",
        add_treetab_section,
        desc="Prompt to add new section in treetab",
    ),
    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Key([mod], "m", lazy.layout.maximize(), desc='Toggle between min and max sizes'),
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    Key(
        [mod, "shift"],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
]
groups = []
group_names = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
]

# group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]
# group_labels = [
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
# ]

group_labels = [
    " ",
    "󰝚 ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
]

group_layouts = [
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            ## mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
            # mod1 + f keys (f + no of group) = move focused window to group
            # Key(
            #     [mod],
            #     "f"+i.name,
            #     lazy.window.togroup(i.name, switch_group=False),
            #     desc="Move focused window to group {}".format(i.name),
            # ),
        ]
    )


### COLORSCHEME ###
# Colors are defined in a separate 'colors.py' file.
# There 11 colorschemes available to choose from:
#
colors = colors.Catppuccin
# colors = colors.DoomOne
# colors = colors.Dracula
# colors = colors.GruvboxDark
# colors = colors.MonokaiPro
# colors = colors.Nord
# colors = colors.OceanicNext
# colors = colors.Palenight
# colors = colors.SolarizedDark
# colors = colors.SolarizedLight
# colors = colors.TomorrowNight
#


### LAYOUTS ###
# Some settings that I use on almost every layout, which saves us
# from having to type these out for each individual layout.
layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": colors[7],
    "border_normal": colors[0],
}

layouts = [
    # layout.Bsp(**layout_theme),
    # layout.Floating(**layout_theme)
    # layout.RatioTile(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    layout.Max(
        border_width=0,
        margin=0,
    ),
    layout.Stack(**layout_theme, num_stacks=2),
    layout.Columns(**layout_theme),
    layout.TreeTab(
        font="Ubuntu Bold",
        fontsize=11,
        border_width=0,
        bg_color=colors[0],
        active_bg=colors[7],
        active_fg=colors[2],
        inactive_bg=colors[1],
        inactive_fg=colors[0],
        padding_left=8,
        padding_x=8,
        padding_y=6,
        sections=["ONE", "TWO", "THREE"],
        section_fontsize=10,
        section_fg=colors[7],
        section_top=15,
        section_bottom=15,
        level_shift=8,
        vspace=3,
        panel_width=240,
    ),
    layout.Zoomy(**layout_theme),
]

# Some settings that I use on almost every widget, which saves us
# from having to type these out for each individual widget.
widget_defaults = dict(
    font="Ubuntu NerdFont Bold", fontsize=12, padding=0, background=colors[0]
)

extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        # widget.Image(
        #          filename = "~/.config/qtile/icons/arch.png",
        #          scale = "False",
        #          mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm)},
        #          ),
        #         widget.GenPollText(
        #                  update_interval = 300,
        #                  func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
        #                  foreground = colors[8],
        #                  fmt = '󰣇  {}',
        #                  mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm)},
        #                  decorations=[
        #                      BorderDecoration(
        #                          colour = colors[8],
        #                          border_width = [0, 0, 2, 0],
        #                      )
        #                  ],
        #                  ),
        widget.Spacer(length=8),
        widget.TextBox(
            text="󰣇",
            font="Ubuntu Mono",
            foreground=colors[6],
            # mouse_callbacks = {'Button1': lazy.spawn(myTerm + ' -e yay', shell=True)},
            mouse_callbacks={
                "Button1": lazy.spawn(
                    'dunstify "I use 󰣇, BTW!" -i /home/zeus/.config/qtile/icons/arch.png',
                    shell=True,
                )
            },
            # mouse_callbacks = {'Button1': lazy.spawn('dunstify "I use 󰣇, BTW!"', shell=True)},
            padding=2,
            fontsize=14,
        ),
        widget.Spacer(length=8),
        # widget.Prompt(
        #          font = "Ubuntu Mono",
        #          fontsize=14,
        #          foreground = colors[1]
        # ),
        widget.GroupBox(
            fontsize=11,
            margin_y=3,
            margin_x=4,
            padding_y=2,
            padding_x=2,
            borderwidth=3,
            active=colors[1],
            inactive=colors[1],
            rounded=False,
            highlight_color=colors[2],
            highlight_method="line",
            this_current_screen_border=colors[7],
            this_screen_border=colors[4],
            other_current_screen_border=colors[7],
            other_screen_border=colors[4],
        ),
        #        widget.Spacer(length = 8),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[1],
            padding=0,
            scale=0.7,
        ),
        # widget.CurrentLayout(
        #          foreground = colors[1],
        #          padding = 5
        #          ),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.Spacer(length=8),
        widget.WindowName(foreground=colors[1], max_chars=40),
        widget.Spacer(length=8),
        #     widget.GenPollText(
        #              update_interval = 300,
        #              func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
        #              foreground = colors[3],
        #              fmt = '❤  {}',
        #              decorations=[
        #                  BorderDecoration(
        #                      colour = colors[3],
        #                      border_width = [0, 0, 2, 0]<S-D-R>
        #                  )
        #              ],
        #              ),
        #        widget.OpenWeather(
        # 		location= "Sydney",
        # 		weather_symbols = {
        # 		        "Unknown": "",
        # 		        "01d": "☀️",
        # 		        "01n": "🌕",
        # 		        "02d": "🌤️",
        # 		        "02n": "☁️",
        # 		        "03d": "🌥️",
        # 		        "03n": "☁️",
        # 		        "04d": "☁️",
        # 		        "04n": "☁️",
        # 		        "09d": "🌧️",
        # 		        "09n": "🌧️",
        # 		        "10d": "⛈",
        # 		        "10n": "⛈",
        # 		        "11d": "🌩",
        # 		        "11n": "🌩",
        # 		        "13d": "❄️",
        # 		        "13n": "❄️",
        # 		        "50d": "🌫",
        # 		        "50n": "🌫",
        # 		    },
        # 		app_key="4d251138ceb3b7db73e25e832da303a4",
        # 		format = "{main_temp: .1f}{units_temperature}: {icon}",
        # 		fmt="{}",
        # 		foreground = colors[1],
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[1],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        #                 ),
        #        custom_widgets.CapsNumLockIndicator(
        #            foreground = colors[4],
        #            fmt = '{}',
        #            format = '{%c}',
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[4],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        #        ),
        widget.Spacer(length=8),
        widget.ThermalSensor(
            format="󰏈 : {temp:.1f}{unit}",
            foreground=colors[1],
            foreground_alert=colors[5],
            threshold=95,
            decorations=[
                BorderDecoration(
                    colour=colors[1],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.CPU(
            format="󰘚  {load_percent}%",
            mouse_callbacks={
                "Button1": lazy.spawn(
                    path + "cpuhoggers",
                    shell=True,
                )
            },
            foreground=colors[4],
            decorations=[
                BorderDecoration(
                    colour=colors[4],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Memory(
            foreground=colors[8],
            mouse_callbacks={
                "Button1": lazy.spawn(
                    path + "memhoggers",
                    shell=True,
                )
            },
            format="{MemUsed: .0f}{mm}",
            fmt="󰍛 {}",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        #        widget.DF(
        #                 update_interval = 60,
        #                 foreground = colors[1],
        #                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
        #                 partition = '/',
        #                 #format = '[{p}] {uf}{m} ({r:.0f}%)',
        #                 format = '{uf}/{s}{m}',
        #                 fmt = '🖴  {}',
        #                 visible_on_warn = False,
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[1],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        #                 ),
        #        widget.Spacer(length = 8),
        #        widget.Volume(
        #                 foreground = colors[7],
        #                 fmt = '🕫  Vol: {}',
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[7],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        #                 ),
        widget.HDD(
            foreground=colors[1],
            fmt="{}",
            mouse_callbacks={
                "Button1": lazy.spawn(
                    path + "storagehoggers",
                    shell=True,
                )
            },
            format=" {HDDPercent}%",
            update_interval=5,
            decorations=[
                BorderDecoration(
                    colour=colors[1],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.PulseVolume(
            foreground=colors[7],
            fmt="󰕾 {}",
            decorations=[
                BorderDecoration(
                    colour=colors[7],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        #        widget.KeyboardLayout(
        #                 foreground = colors[4],
        #                 fmt = '⌨  Kbd: {}',
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[4],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        #                 ),
        widget.Battery(
            # chars
            charge_char="󰢞",
            discharge_char="󰁾",
            empty_char="󰂃",
            full_char="󰁹",
            unknown_char="󰚥",
            foreground=colors[5],
            low_foreground=colors[4],
            format="{char}  {percent:2.0%} {hour:d}:{min:02d}",
            notify_below=5,
            decorations=[
                BorderDecoration(
                    colour=colors[5],
                    border_width=[0, 0, 2, 0],
                )
            ],
            update_interval=30,
        ),
        widget.Spacer(length=8),
        widget.Clock(
            foreground=colors[1],
            format="  %a, %b %d - %H:%M",
            # timezone = "Australia/NSW",
            decorations=[
                BorderDecoration(
                    colour=colors[1],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        # 	widget.CheckUpdates(
        # 		distro = 'Arch_yay',
        # 		colour_no_updates = colors[5],
        # 		colour_have_updates = colors[4],
        # 		display_format = ' 󰚰 :{updates}',
        # 		no_update_string = '  ',
        # 		update_interval = 86400,
        #                 decorations=[
        #                     BorderDecoration(
        #                         colour = colors[5],
        #                         border_width = [0, 0, 2, 0],
        #                     )
        #                 ],
        # 		),
        #        widget.Spacer(length = 8),
        #        widget.Systray(
        #                padding = 3,
        #                icon_size = 16,
        #                decorations=[
        #                    BorderDecoration(
        #                        colour = "#ffffff",
        #                        border_width = [0, 0, 2, 0],
        #                    )
        #                ],
        #                ),
        #        widget.Spacer(length = 8),
    ]
    return widgets_list


# Monitor 1 will display ALL widgets in widgets_list. It is important that this
# is the only monitor that displays all widgets because the systray widget will
# crash if you try to run multiple instances of it.
def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    del widgets_screen2[10:]
    return widgets_screen2


# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=16)),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=16)),
    ]


#            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="kdenlive"),  # kdenlive
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(wm_class="Yad"),  # yad boxes
        Match(wm_class="oblogout"),  # oblogout
        Match(title="branchdialog"),  # gitk
        Match(title="Confirmation"),  # tastyworks exit box
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="tastycharts"),  # tastytrade pop-out charts
        Match(title="tastytrade"),  # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"),  # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),  # tastytrade settings
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"
