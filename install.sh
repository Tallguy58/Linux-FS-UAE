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
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-victoria.xml'"
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

apt-get -y install fs-uae
apt-get -y install fs-uae-launcher
apt-get -y install fs-uae-arcade

mkdir -p -v /home/$currentuser/Documents/FS-UAE/Configurations
cp -v -f configs/*.fs-uae /home/$currentuser/Documents/FS-UAE/Configurations/

mkdir -p -v /home/$currentuser/Documents/FS-UAE/Hard\ Drives/Work
rsync -ah --progress wbsystems/* /home/$currentuser/Documents/FS-UAE/Hard\ Drives/Work
fallocate -l 32G /home/$currentuser/Documents/FS-UAE/Hard\ Drives/system.hdf

mkdir -p -v /home/$currentuser/Documents/FS-UAE/Kickstarts
cp -v -f rom/* /home/$currentuser/Documents/FS-UAE/Kickstarts/

mkdir -p -v /home/$currentuser/Documents/FS-UAE/Floppies
cp -v -f adf/*.adf /home/$currentuser/Documents/FS-UAE/Floppies/

echo -e '[Desktop Entry]'>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'Type=Application'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'Exec=fs-uae'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'X-GNOME-Autostart-enabled=true'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'NoDisplay=false'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'Hidden=false'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'Name[en_AU]=Launch Amiga'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'Comment[en_AU]=Commodore Amiga Emulator'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop
echo -e 'X-GNOME-Autostart-Delay=0'>>/home/$currentuser/.config/autostart/LaunchAmiga.desktop

chmod 0777 -R /home/$currentuser

sleep 5
shutdown -r now
