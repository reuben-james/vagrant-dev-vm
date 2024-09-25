#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git gnupg2 

# Install Desktop
sudo apt-get install -y --no-install-recommends ubuntu-desktop
sudo apt-get install -y --no-install-recommends virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo usermod -a -G sudo vagrant
# Desktop essentials
sudo apt install -y gnome-tweaks gnome-shell-extensions 

# Install Chrome/Firefox
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub|sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo apt install -y google-chrome-stable
sudo apt install -y firefox

# Other shit
sudo chown -R vagrant:vagrant /home/vagrant/*
mkdir /home/vagrant/Desktop
sudo cp /vagrant/id_rsa ~/.ssh
sudo cp /vagrant/id_rsa.pub ~/.ssh
sudo cp /vagrant/known_hosts ~/.ssh
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa

# Install VNC Server
# sudo apt install tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer -y
# mkdir -p /home/vagrant/.vnc
# echo vncpass | vncpasswd -f > /home/vagrant/.vnc/passwd
# chmod 0600 ~/.vnc/passwd
# cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
# sed -i "s/<USER>/vagrant/g" /etc/systemd/system/vncserver@:1.service
# systemctl daemon-reload
# systemctl enable vncserver@:1.service
# systemctl start vncserver@:1.service

sudo shutdown -h now