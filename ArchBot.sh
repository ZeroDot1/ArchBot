#!/bin/bash
echo "This script will update your system . . . . "
echo "Please enter your password in the next step to be able to update the system."
echo "First the update servers are updated and then the system - this can take some time."
echo "Please perform updates a minimum of once a week."
tput setaf 117 && sleep 1s
cd

notify-send "ArchBot" "Update the systemtime."
sudo rm -rf /var/db/ntp-kod
sudo touch /var/db/ntp-kod
sudo sntp -s 3.de.pool.ntp.org
sudo systemctl restart systemd-timesyncd.service
sudo hwclock -w
clear

# Update Mirrors
notify-send "ArchBot" "Download & Update Mirrors"
rm -rf ~/Downloads/mirrorlist
rm -rf ~/Downloads/mirrorlist.fastest
curl --tcp-fastopen --tcp-nodelay --tr-encoding -f -v --compressed -L --http2 --ignore-content-length --max-time 35 "APIs-Google (+https://developers.google.com/webmasters/APIs-Google.html)" "https://archlinux.org/mirrorlist/?country=CL&country=DK&country=DE&country=HK&country=SG&country=US&protocol=https&ip_version=6&use_mirror_status=on" >> ~/Downloads/mirrorlist
sed -i 's/#S/S/g' ~/Downloads/mirrorlist
rankmirrors ~/Downloads/mirrorlist > ~/Downloads/mirrorlist.fastest
sudo mv -v ~/Downloads/mirrorlist.fastest /etc/pacman.d/mirrorlist

notify-send "ArchBot" "Install all available updates, this may take a while, relax. . ."
yay -S --noconfirm --cleanafter --nodiffmenu --noeditmenu --sudoloop arcolinux-keyring gnome-keyring archlinux-keyring --overwrite "*"
yay -Syu --devel --noconfirm --cleanafter --nodiffmenu --noeditmenu --sudoloop --overwrite "*"
notify-send "ArchBot" "Install updates from the Arch User Repository."
echo "Install updates from the Arch User Repository."

notify-send "ArchBot" "Clean pacman's mouth to keep the SSDs clean..."
echo "Clean pacman's mouth to keep the SSD clean..."
paccache --remove --uninstalled --keep 0
paccache --remove --keep 1

notify-send "ArchBot" "Please restart the computer so that all updates can be applied and please make sure that you have saved everything before restarting."
echo "Please restart the computer so that all updates can be applied and please make sure that you have saved everything before restarting."
echo "Do you want to restart the computer? y/n"
read rb
if [ $rb == y ]
	then
		systemctl reboot -i
else
	exit
fi
