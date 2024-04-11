#!/bin/bash

# Text decoration
Red="\033[0;31m"
Bold="\033[1m"
Color_Off="\033[0m"
Cyan="\033[0;36m"
Green="\033[0;32m"
user_name=$(who | cut -d ' ' -f 1 | head -1)

# Find Cisco Packet Tracer installer
localized_installers=()
selected_installer=''

echo -e "${Green}${Bold}Searching for installers in user home...${Color_Off}\n"
c=1
for installer in $(find /home/$user_name -type f -name "Cisco*Packet*.deb" -o -name "Packet*Tracer*.deb"); do
  localized_installers[$c]=$installer
  ((c++))
done

clear

if [[ -z "${localized_installers[@]}" ]]; then
  echo -e "\n${Red}${Bold}Packet Tracer installer not found in /home. It must be named like this: $installer_name_1.$Color_Off\n"
  echo -e "You can download the installer from ${Cyan}https://www.netacad.com/portal/resources/packet-tracer${Color_Off} \
or ${Cyan}https://skillsforall.com/resources/lab-downloads${Color_Off} (login required)."
  exit 1
elif [ "${#localized_installers[@]}" -eq 1 ]; then
  selected_installer="${localized_installers[1]}"
else
 
  echo -e "${Red}${Bold}Press CTRL + C to cancel installation.${Color_Off}\n"
  echo -e "${Cyan}${Bold}$((c-1)) installers of Cisco Packet Tracer was founded:${Color_Off}\n"

  PS3="Select a installer to use: "

  select installer in ${localized_installers[@]}
  do
    selected_installer=$installer
    break
  done
fi

echo -e "\n${Bold}Selected installer: ${Red}${Bold}$selected_installer ${Color_Off}\n"
sleep 3

echo "Removing old version of Packet Tracer from /opt/pt"
sudo bash ./uninstall.sh

echo "Installing dependencies"
sudo dnf -y install binutils qt5-qt{multimedia,webengine,networkauth,websockets,webchannel,script,location,svg,speech}

echo "Extracting files"
mkdir packettracer
ar -x $selected_installer --output=packettracer
tar -xvf packettracer/control.tar.xz --directory=packettracer
tar -xvf packettracer/data.tar.xz --directory=packettracer

sudo cp -r packettracer/usr /
sudo cp -r packettracer/opt /
sudo sed -i 's/sudo xdg-mime/sudo -u $SUDO_USER xdg-mime/' ./packettracer/postinst
sudo sed -i 's/sudo gtk-update-icon-cache --force/sudo gtk-update-icon-cache -t --force/' ./packettracer/postinst
sudo sed -i 's/CONTENTS="$CONTENTS\\n$line"/CONTENTS="$CONTENTS\
$line"/' ./packettracer/postinst
sudo ./packettracer/postinst
sudo sed -i 's/packettracer/packettracer --no-sandbox args/' /usr/share/applications/cisco-pt*.desktop
sudo rm -rf packettracer