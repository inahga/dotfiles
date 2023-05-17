#!/bin/sh
# Total rip from https://github.com/whereswaldon/configuration/blob/public/river/init

export XDG_CURRENT_DESKTOP=river
export XCURSOR_THEME=Numix-Cursor-Light

if [ $HIDPI == "1" ]; then
	export XCURSOR_SIZE=48
	export QT_SCALE_FACTOR="2.0"
	PADDING=3
else
	export XCURSOR_SIZE=24
	export QT_SCALE_FACTOR="1.0"
	PADDING=1
fi

set_background() {
	riverctl background-color 0x000000
	riverctl border-color-unfocused 0x93a1a1
	riverctl border-color-focused 0x000000
	swaybg -m fill -i "$(fd jpg "$HOME/Pictures/wallpapers" | shuf | head -n1)" &
}

set_environment() {
	# Ensure that the systemd user session has the necessary environment for
	# xdg-desktop-portal-wlr.
	dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP="$XDG_CURRENT_DESKTOP"

	# Stop any services that are running, so that they receive the new env var when they restart.
	systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
	systemctl --user start wireplumber

	riverctl set-repeat 50 300                                # set key repeat rate
	riverctl float-filter-add app-id float                    # type of window to float by default
	riverctl float-filter-add title "popup title with spaces" # title of window to float by default

	# riverctl csd-filter-add app-id "gedit" # apps that should use client-side decorations

	# Configure preferred touchpad stuff.
	riverctl input "pointer-1267-12693-ELAN0678:00_04F3:3195_Touchpad" tap enabled
	riverctl input "pointer-1267-12693-ELAN0678:00_04F3:3195_Touchpad" drag enabled
	riverctl input "pointer-1267-12693-ELAN0678:00_04F3:3195_Touchpad" pointer-accel 0.4
	riverctl xcursor-theme $XCURSOR_THEME $XCURSOR_SIZE
}

set_bindings() {
	riverctl map normal Super Space spawn fuzzel               # start launcher
	riverctl map normal Super Q close                          # close current view
	riverctl map normal Super+Shift E exit                     # exit river
	riverctl map normal Control+Alt Delete spawn "swaylock -f" # lock screen
	riverctl map normal Super J focus-view next
	riverctl map normal Super K focus-view previous
	riverctl map normal Super+Shift J swap next
	riverctl map normal Super+Shift K swap previous
	riverctl map normal Super Period focus-output next
	riverctl map normal Super Comma focus-output previous
	riverctl map normal Super+Shift Period send-to-output next
	riverctl map normal Super+Shift Comma send-to-output previous
	riverctl map normal Super Return zoom
	riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
	riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"
	riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
	riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"
	riverctl map normal Super+Alt H move left 100
	riverctl map normal Super+Alt J move down 100
	riverctl map normal Super+Alt K move up 100
	riverctl map normal Super+Alt L move right 100
	riverctl map normal Super+Alt+Control H snap left
	riverctl map normal Super+Alt+Control J snap down
	riverctl map normal Super+Alt+Control K snap up
	riverctl map normal Super+Alt+Control L snap right
	riverctl map normal Super+Alt+Shift H resize horizontal -100
	riverctl map normal Super+Alt+Shift J resize vertical 100
	riverctl map normal Super+Alt+Shift K resize vertical -100
	riverctl map normal Super+Alt+Shift L resize horizontal 100
	riverctl map-pointer normal Super BTN_LEFT move-view
	riverctl map-pointer normal Super BTN_RIGHT resize-view
	riverctl map-pointer normal Super BTN_MIDDLE toggle-float

	for i in $(seq 1 9); do
		tags=$((1 << ($i - 1)))
		riverctl map normal Super $i set-focused-tags $tags               # focus tag
		riverctl map normal Super+Shift $i set-view-tags $tags            # tag view
		riverctl map normal Super+Control $i toggle-focused-tags $tags    # toggle focus of tag
		riverctl map normal Super+Shift+Control $i toggle-view-tags $tags # toggle tag of focused view
	done

	# Super+0 to focus all tags
	# Super+Shift+0 to tag focused view with all tags
	all_tags=$(((1 << 32) - 1))
	riverctl map normal Super 0 set-focused-tags $all_tags
	riverctl map normal Super+Shift 0 set-view-tags $all_tags

	riverctl map normal Super F toggle-float
	riverctl map normal Super Z toggle-fullscreen

	# Super+{Up,Right,Down,Left} to change layout orientation
	riverctl map normal Super Up send-layout-cmd rivertile "main-location top"
	riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
	riverctl map normal Super Down send-layout-cmd rivertile "main-location bottom"
	riverctl map normal Super Left send-layout-cmd rivertile "main-location left"

	# Configure screenshot shortcuts.
	riverctl map normal None Print spawn 'grim "$(xdg-user-dir PICTURES)"/"$(date +"%s_grim.png")"'
	riverctl map normal Control Print spawn 'grim -g "$(slurp)" "$(xdg-user-dir PICTURES)"/"$(date +"%s_grim.png")"'
	riverctl map normal Shift Print spawn 'grim - | wl-copy'
	riverctl map normal Shift+Control Print spawn 'grim -g "$(slurp)" - | wl-copy'

	# Declare a passthrough mode. This mode has only a single mapping to return to
	# normal mode. This makes it useful for testing a nested wayland compositor
	riverctl declare-mode passthrough
	riverctl map normal Super F11 enter-mode passthrough
	riverctl map passthrough Super F11 enter-mode normal

	# Set these to run in both normal and locked mode.
	for mode in normal locked; do
		riverctl map $mode None XF86AudioRaiseVolume spawn 'pamixer -i 5'
		riverctl map $mode None XF86AudioLowerVolume spawn 'pamixer -d 5'
		riverctl map $mode None XF86AudioMute spawn 'pamixer --toggle-mute'
		riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
		riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
		riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
		riverctl map $mode None XF86AudioNext spawn 'playerctl next'
		riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl set +10%'
		riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 10%-'
	done
}

spawn_daemons() {
	swayidle -w \
		timeout 900 'swaylock -f' \
		timeout 905 'wlopm --off "*"' \
		resume 'wlopm --on' \
		before-sleep 'swaylock -f' |
		sed -e 's/^/swayidle: /' &                         # idle timeout daemon
	sleep 0.1 && kanshi 2>&1 | sed -e 's/^/kanshi: /' & # display management daemon
	sleep 0.1 && mako 2>&1 | sed -e 's/^/mako: /' &     # notification daemone
}

spawn_waybar() {
	waybar 2>&1 | sed -e 's/^/waybar: /' &
}

spawn_waybar
set_background
set_bindings
set_environment
spawn_daemons

# Set and exec into the default layout generator, rivertile.
# River will send the process group of the init executable SIGTERM on exit.
riverctl default-layout rivertile
exec rivertile -view-padding $PADDING -outer-padding $PADDING
