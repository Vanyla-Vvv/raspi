#!/bin/bash
#RED="\033[0;31m"
#GREEN="\033[0;32m"
#YELLOW="\033[0;33m"
#RASPBERRY="\033[0;35m"
#ERROR="\033[1;37;41m"
#RESET="\033[m"
#!/bin/bash

if [ -z "${1}" ]
then
echo -e "\n\033[0;31mNeed a password"
exit 1
fi
if [[ ${a} == "PASSWORD" ]]
then
${1} = date +%s | sha256sum | base64 | head -c 32
echo -e "\n\033[0;31mPassword generated: ${1} and file: password"
echo -e "${1}" | sudo tee ~/password > /dev/null
fi
printf "\n\n\n\033[0;31m███╗   ███╗ ██████╗ \n████╗ ████║██╔═══██╗\n██╔████╔██║██║   ██║\n██║╚██╔╝██║██║▄▄ ██║\n██║ ╚═╝ ██║╚██████╔╝\n╚═╝     ╚═╝ ╚══▀▀═╝ \n"

function vsftpd {
sudo apt install vsftpd -y > /dev/null 2>&1
}
x=1
function getPrint {
if [[ "$x" == 1 ]]
then
  let "x+=1"
  printf "\b"
  sleep 5
elif [[ "$x" == 2 ]]
then
  let "x+=1"
  printf "\b"
  sleep 5
elif [[ "$x" == 3 ]]
then
  let "x+=1"
  printf "\b"
  sleep 5
elif [[ "$x" == 4 ]]
then
  let "x+=1"
  printf "."
  sleep 5
elif [[ "$x" == 5 ]]
then
  let "x+=1"
  printf "."
  sleep 5
elif [[ "$x" == 6 ]]
then
  let "x-=5"
  printf "."
  sleep 5
fi
}
v_vsftpd=0
printf "\033[0;33m"
while true; do
    read -p "Install FTP?" yn
    case $yn in
        [Yy]* ) v_vsftpd=1; break;;
        [Nn]* ) v_vsftpd=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_vsftpd" -eq 1 ]
then
printf "\n\n\n\033[0;33m███████╗████████╗██████╗ \n██╔════╝╚══██╔══╝██╔══██╗\n█████╗     ██║   ██████╔╝\n██╔══╝     ██║   ██╔═══╝ \n██║        ██║   ██║     \n╚═╝        ╚═╝   ╚═╝     \n"
printf "\033[0;33m\nInstall FTP..."
until vsftpd
do
  getPrint
done
printf "\n\033[0;32mFTP Install done!\033[m\n"

until sudo rm /etc/vsftpd.conf 2> /dev/null
do
  sleep 1
done

mkdir -p /home/$USER/FTP
echo -e "anonymous_enable=NO\nwrite_enable=YES\nlocal_umask=022\ndirmessage_enable=YES\nxferlog_enable=YES\nconnect_from_port_20=YES\nchroot_local_user=YES\nlisten=YES\nuser_sub_token=\$USER\nlocal_root=/home/\$USER/FTP" | sudo tee /etc/vsftpd.conf > /dev/null

chmod -R 766 /home/$USER/FTP
fi
v_mysql=0
printf "\033[0;33m"
while true; do
    read -p "Install MySQL?" yn
    case $yn in
        [Yy]* ) v_mysql=1; break;;
        [Nn]* ) v_mysql=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_mysql" -eq 1 ]
then
printf "\n\n\n\n\033[0;33m███╗   ███╗██╗   ██╗███████╗ ██████╗ ██╗     \n████╗ ████║╚██╗ ██╔╝██╔════╝██╔═══██╗██║     \n██╔████╔██║ ╚████╔╝ ███████╗██║   ██║██║     \n██║╚██╔╝██║  ╚██╔╝  ╚════██║██║▄▄ ██║██║     \n██║ ╚═╝ ██║   ██║   ███████║╚██████╔╝███████╗\n╚═╝     ╚═╝   ╚═╝   ╚══════╝ ╚══▀▀═╝ ╚══════╝\n\033[m"

function mariadb {
sudo apt install mariadb-server -y > /dev/null 2>&1
}

printf "\033[0;33m\nInstall MariaDB..."
until mariadb
do
  getPrint
done
printf "\n\033[0;32mMariaDB Install done!\nSetting secure MariaDB\033[m\n"

sudo mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${1}');"
sudo mysql -e "DROP USER IF EXISTS ''@'localhost';"
sudo mysql -e "DROP USER IF EXISTS ''@'$(hostname)';"
sudo mysql -e "DROP USER IF EXISTS ''@'%';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS hi;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'vanyla'@'%' IDENTIFIED BY '${1}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON hi.* TO 'vanyla'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

function php-mysql {
sudo apt install php-mysql -y > /dev/null 2>&1
}

printf "\033[0;33m\nInstall PHP-MySQL..."
until php-mysql
do
  getPrint
done

printf "\n\033[0;32mPHP-MySQL Install done!\033[m\n"
fi


v_nordvpn=0
printf "\033[0;33m"
while true; do
    read -p "Install Nord VPN?" yn
    case $yn in
        [Yy]* ) v_nordvpn=1; break;;
        [Nn]* ) v_nordvpn=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_nordvpn" -eq 1 ]
then
printf "\033[0;33m\nInstall Nord VPN\n\033[m"

sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

printf "\n\033[0;32mNord VPN Install done! \033[m\n"
fi

v_pihole=0
printf "\033[0;33m"
while true; do
    read -p "Install PiHole? RaspAP don't running with PiHole" yn
    case $yn in
        [Yy]* ) v_pihole=1; break;;
        [Nn]* ) v_pihole=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_pihole" -eq 1 ]
then
printf "\033[0;33m\nInstall Pi-Hole\n\033[m"

curl -sSL https://install.pi-hole.net | bash
sudo pihole -a -p ${1}
printf "\n\033[0;32mPi-Hole Install done!\033[m\n"
fi

v_raspap=0
if [ "$v_pihole" -eq 0 ]
then
printf "\033[0;33m"
while true; do
    read -p "Install RaspAP?" yn
    case $yn in
        [Yy]* ) v_raspap=1; break;;
        [Nn]* ) v_raspap=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_raspap" -eq 1 ]
then
printf "\033[0;33m\nInstall RaspAP\n\033[m"

curl -sL https://install.raspap.com | bash -s -- --cert


printf "\n\033[0;32mRaspAP Install done! Please set up RaspAP!!! \033[m\n"
fi
fi


if [ "$v_mysql" -eq 1 ]
then
printf "\033[0;33m\nInstall phpmyadmin\n\033[m"
sudo apt install phpmyadmin -y
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo phpenmod mysqli
fi

v_samba=0
printf "\033[0;33m"
while true; do
    read -p "Install SAMBA?" yn
    case $yn in
        [Yy]* ) v_samba=1; break;;
        [Nn]* ) v_samba=0; break;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
if [ "$v_samba" -eq 1 ]
then
sudo apt-get install samba samba-common-bin
mkdir /home/pi/FTP /home/pi/FTP/manga
sudo chmod 1766 -R /home/pi/FTP /home/pi/FTP/manga
sudo cp /etc/samba/smb.conf -R /etc/samba/smb.conf.old
sudo rm -R /etc/samba/smb.conf
curl https://raw.githubusercontent.com/Vanyla-Vvv/raspi/main/smb.conf | sudo tee /etc/samba/smb.conf > /dev/null
sudo smbpasswd -a pi
sudo systemctl restart smbd
fi
#Reboot
sudo apt update
sudo apt upgrade -y

printf "\033[0;33m"
while true; do
    read -p "Reboot?" yn
    case $yn in
        [Yy]* ) sudo reboot; exit;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes (yY) or no (nN).";;
    esac
done
printf "\033[m"
