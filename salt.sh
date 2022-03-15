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

printf "\n\n\n\033[0;31m███╗   ███╗ ██████╗ \n████╗ ████║██╔═══██╗\n██╔████╔██║██║   ██║\n██║╚██╔╝██║██║▄▄ ██║\n██║ ╚═╝ ██║╚██████╔╝\n╚═╝     ╚═╝ ╚══▀▀═╝ \n\n\n\n\033[0;33m███████╗████████╗██████╗ \n██╔════╝╚══██╔══╝██╔══██╗\n█████╗     ██║   ██████╔╝\n██╔══╝     ██║   ██╔═══╝ \n██║        ██║   ██║     \n╚═╝        ╚═╝   ╚═╝     \n"

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

chmod -R 666 /home/$USER/FTP

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
printf "\033[0;33m\nInstall Pi-Hole\n\033[m"

curl -sSL https://install.pi-hole.net | bash
sudo pihole -a -p ${1}
printf "\n\033[0;32mPi-Hole Install done!\033[m\n"

printf "\033[0;33m\nInstall phpmyadmin\n\033[m"
sudo apt install phpmyadmin -y
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo phpenmod mysqli

sudo apt-get install samba samba-common-bin
mkdir /home/pi/FTP /home/pi/FTP/manga
sudo chmod 1766 -R /home/pi/FTP /home/pi/FTP/manga
sudo cp /etc/samba/smb.conf -R /etc/samba/smb.conf.old
sudo rm -R /etc/samba/smb.conf
curl https://raw.githubusercontent.com/Vanyla-Vvv/raspi/main/smb.conf | sudo tee /etc/samba/smb.conf > /dev/null
sudo smbpasswd -a pi
sudo systemctl restart smbd

#Reboot
sudo apt update
sudo apt upgrade -y
sudo reboot
