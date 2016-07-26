#!/bin/bash

apt-get update

# Install chromium browser
sudo apt-get install -y chromium-browser

# Install ICAClient
cd /tmp
wget http://www.vinnymac.org/downloads/citrix/icaclient-mod-ubuntu-14-04.deb
sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
sudo apt-get -f -y install
#sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

# Set startup apps (e.g., chromium)
cp /tmp/install/startapp.sh /startapp.sh
chmod +x /startapp.sh

# Clean up
sudo apt-get autoremove
