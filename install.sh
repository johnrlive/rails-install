#!/bin/bash

script_runner=$(whoami)

if [ $script_runner == "root" ] ; then
  echo -e "\nFor security reasons this script must be run as a normal user with sudo privileges\n"
  exit 1
fi

clear
echo '[Welcome to ee-install script]'
echo '(setup can take more 5 minutes)'

#Start install prerequisite
echo '[###### Update server ######]'
sleep 1
sudo apt-get -y update
sudo apt-get -y upgrade
echo '[###### Done ######]'
sleep 1


echo '[###### Install utility tool ######]'
sleep 1
sudo apt-get install -y mc git-core curl
echo '[###### Done ######]'
sleep 1


echo '[###### Install Files ######]'
sleep 1
sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev
sudo apt-get install -y libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
echo '[###### Done ######]'
sleep 1


echo '[###### Install Nginx ######]'
sleep 1
echo '[Install Phusions PGP key to verify packages]'
gpg --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
gpg --armor --export 561F9B9CAC40B2F7 | sudo apt-key add -
echo '[Add HTTPS support to APT]'
sleep 1
sudo apt-get install -y apt-transport-https
echo '[Add the passenger repository]'
sleep 1
sudo sh -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list"
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get -y update
echo '[Install nginx and passenger]'
sleep 1
sudo apt-get install -y nginx-full passenger
sleep 1
sudo service nginx start
echo '[###### Done ######]'
sleep 1


echo '[###### Install Database Sqlite3 ######]'
sleep 1
sudo apt-get install -y sqlite3 libsqlite3-dev
echo '[###### Done ######]'
sleep 1


echo '[###### Install Database PostgreSQL ######]'
sleep 1
sudo apt-get install -y postgresql postgresql-contrib libpq-dev
sudo su - postgres
createuser --pwprompt
echo '[###### Done ######]'
sleep 1


echo '[###### Install Fail2ban ######]'
sleep 1
sudo apt-get install -y fail2ban
sudo cp -f nginx-req-limit.conf /etc/fail2ban/filter.d/nginx-req-limit.conf
sudo cp -f jail.local /etc/fail2ban/jail.local
sudo service fail2ban restart
echo '[###### Done ######]'
sleep 1


echo '[###### Adds bash_profile with aliases ######]'
sleep 1
sudo cp -f .profile ~/.profile
source ~/.profile
echo '[###### Done #####]'
sleep 1


echo '[###### Setup Unattended Updates ######]'
sleep 1
sudo apt-get install unattended-upgrades
sudo cp -f 10periodic /etc/apt/apt.conf.d/10periodic
sudo cp -f 50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
echo '[###### Done #####]'
sleep 1


echo '[###### Adds bash_profile with aliases ######]'
sleep 1
sudo apt-get install logwatch
sudo vim /etc/cron.daily/00logwatch
echo 'add this line: /usr/sbin/logwatch --output mail --mailto test@gmail.com --detail high'
echo '[###### Done #####]'
sleep 1

exit
