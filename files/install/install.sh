#!/bin/bash

apt-get update
cd /tmp
wget http://www.vinnymac.org/downloads/citrix/icaclient-mod-ubuntu-14-04.deb
sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
sudo apt-get -f -y install
sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

#sudo apt-get install gconf-service libgconf-2-4 libatk1.0-0 libgtk2.0-0 libnspr4 libnss3 libxss1 libnss3 xdg-utils chromium-codecs-ffmpeg-extra chromium-codecs-ffmpeg chromium-browser-l10n
sudo apt-get install chromium-browser
sudo apt-get -f -y install
#sudo apt-get install chromium-browser


cp /tmp/install/startapp.sh /startapp.sh
chmod +x /startapp.sh
