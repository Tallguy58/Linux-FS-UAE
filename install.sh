#!/bin/bash

currentuser=$(users | awk '{print $1}')

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "($_display_id)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

# Desktop Icon Settings
run-in-user-session dconf write /org/nemo/desktop/computer-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/home-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/network-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/show-orphaned-desktop-icons "false"
run-in-user-session dconf write /org/nemo/desktop/trash-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/volumes-visible "false"
# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-wallpapers.xml'"
#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"
# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"
#Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"

add-apt-repository ppa:fengestad/stable
apt-get -y update
apt-get -y install fs-uae
apt-get -y install fs-uae-launcher
apt-get -y install fs-uae-arcade

mkdir -p /home/$currentuser/Documents/FS-UAE/Hard\ Drives/Work
rsync -ah --progress wbsystems/* /home/$currentuser/Documents/FS-UAE/Hard\ Drives/Work
fallocate -l 32G /home/$currentuser/Documents/FS-UAE/Hard\ Drives/system.hdf

mkdir -p /home/$currentuser/Documents/FS-UAE/Kickstarts
cp -v -f rom/* /home/$currentuser/Documents/FS-UAE/Kickstarts/

mkdir -p /home/$currentuser/Documents/FS-UAE/Floppies
cp -v -f adf/*.adf /home/$currentuser/Documents/FS-UAE/Floppies/

mkdir -p /home/$currentuser/.config/autostart
cat <<'EOF' >/home/$currentuser/.config/autostart/LaunchAmiga.desktop
[Desktop Entry]
Type=Application
Exec=fs-uae
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[en_AU]=Launch Amiga
Comment[en_AU]=Commodore Amiga Emulator
X-GNOME-Autostart-Delay=0
EOF

mkdir -p /home/$currentuser/Documents/FS-UAE/Configurations
cat <<'EOF' >/home/$currentuser/Documents/FS-UAE/Configurations/Default.fs-uae
[fs-uae]
amiga_model = A1200/020
bsdsocket_library = 1
chip_memory = 2048
cpu = 68020
accuracy = 0
uae_cpu_speed = max
uae_fpu_model = 68882
jit_compiler = 1
fast_memory = 4096
slow_memory = 1536
floppy_drive_count = 4
floppy_drive_speed = 800
floppy_image_0 = AmigaTestKit 1.21.adf
floppy_image_1 = xsysinfo-v0.6.1.adf
floppy_image_2 = Install 3.2HD.adf
floppy_image_3 = Restore Archive Disc.adf
force_aspect = 1.7777777777777777
fullscreen mode = fullscreen
fullscreen = 1
graphics_card = uaegfx-z3
graphics_memory = 16384
hard_drive_0 = system.hdf
hard_drive_0_controller = ide0
hard_drive_0_priority = -40
hard_drive_0_type = RDF
hard_drive_1 = Work
hard_drive_1_priority = -127
hard_drive_1_label = PC Files
kickstart_file = kick323.rom
network_card = a2065
platform = amiga
uae_floppy0type = 1
uae_floppy1type = 1
uae_floppy2type = 1
uae_floppy3type = 1
writable_floppy_images = 1
uae_sound_output = exact
uae_sound_stereo_separation = 16
zorro_iii_memory = 520192
EOF

chmod 0777 -R /home/$currentuser

sleep 5
shutdown -r now