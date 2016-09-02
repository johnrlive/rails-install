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
sudo apt-get -y install aptitude
echo '[###### Done ######]'
sleep 1


echo '[###### Install utility tool ######]'
sleep 1
sudo apt-get install -y vim git git-core curl mc
echo '[###### Done ######]'
sleep 1


echo '[###### Install System Repos ######]'
sleep 1
sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev
sudo apt-get install -y libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
echo '[###### Done ######]'
sleep 1


echo '[###### Install Node.JS Repos ######]'
sleep 1
sudo apt-get install -y nodejs npm
echo '[###### Done ######]'
sleep 1


echo '[###### Install Database Sqlite3 ######]'
sleep 1
sudo apt-get install -y libsqlite3-dev sqlite3
echo '[###### Done ######]'
sleep 1


echo '[###### Install rbenv ######]'
sleep 1
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
# echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
# source ~/.bash_profile

git clone git://github.com/sstephenson/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars


#if [ -d "$HOME/.rbenv" ]; then
#  export GEM_PATH=$GEM_PATH:$HOME/.gems
#  export PATH=$HOME/.rbenv/bin:$PATH;
#  export RBENV_ROOT=$HOME/.rbenv;
#  eval "$(rbenv init -)";
#fi



#    - name: Install Ruby
#      shell: bash -lc "rbenv install {{ ruby_version }} && rbenv rehash"
#      when:
#        - ruby_installed.rc != 0
#
#    - name: Set Global Ruby Version
#      shell: bash -lc "rbenv global {{ ruby_version }} && rbenv rehash"
#
#   - name: Clone rbenv-vars to ~/.rbenv
#      git: repo=https://github.com/sstephenson/rbenv-vars.git
#        dest="~/.rbenv/plugins/rbenv-vars"



echo '[###### Install Nginx ######]
sudo apt-get -y install nginx
sudo ufw allow 'Nginx Full'
# sudo cp nginx.sh /etc/nginx/sites-available/firstsite

sudo systemctl restart nginx
sudo systemctl start uwsgi
sudo systemctl enable nginx
sudo systemctl enable uwsgi






# echo '[###### Install Database PostgreSQL ######]'
# sleep 1
# sudo apt-get install -y postgresql postgresql-contrib libpq-dev
# sudo su - postgres
# createuser --pwprompt
# echo '[###### Done ######]'
# sleep 1


echo '[###### Install Fail2ban ######]'
sleep 1
sudo apt-get install -y fail2ban
sudo cp -f nginx-req-limit.conf /etc/fail2ban/filter.d/nginx-req-limit.conf
sudo cp -f jail.local /etc/fail2ban/jail.local
sudo service fail2ban restart
echo '[###### Done ######]'
sleep 1


# echo '[###### Adds bash_profile with aliases ######]'
#sleep 1
#sudo cp -f .profile ~/.profile
#source ~/.profile
#echo '[###### Done #####]'
#sleep 1


echo '[###### Setup Unattended Updates ######]'
sleep 1
sudo apt-get install unattended-upgrades
sudo cp -f 10periodic /etc/apt/apt.conf.d/10periodic
sudo cp -f 50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
echo '[###### Done #####]'
sleep 1


echo '[###### Adds logwatch ######]'
sleep 1
sudo apt-get install logwatch
sudo vim /etc/cron.daily/00logwatch
echo 'add this line: /usr/sbin/logwatch --output mail --mailto test@gmail.com --detail high'
echo '[###### Done #####]'
sleep 1

exit
