#!/bin/bash

# Install via mark911 instructions
sudo dpkg --add-architecture i386
sudo apt-get update

sudo apt-get install -f -y firefox
sudo apt-get install -f -y xdg-utils

sudo dpkg -i /tmp/icaclient_*.deb
sudo apt-get -f install

sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/

sudo rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so /usr/lib/firefox/plugins/npwrapper.npica.so
sudo rm -f /usr/lib/mozilla/plugins/npica.so
sudo ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/mozilla/plugins/npica.so
sudo ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

xdg-mime default wfica.desktop application/x-ica

# Set startup apps (e.g., mozilla)
cp /tmp/install/startapp.sh /startapp.sh
chmod +x /startapp.sh
