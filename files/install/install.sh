#!/bin/bash

apt-get update
cd /tmp
wget http://www.vinnymac.org/downloads/citrix/icaclient-mod-ubuntu-14-04.deb
sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
sudo apt-get install -f
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

sudo apt-get install chromium-browser

cp /tmp/install/startapp.sh /startapp.sh
chmod +x /startapp.sh
