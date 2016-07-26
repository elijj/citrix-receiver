FROM hurricane/dockergui:x11rdp1.3
MAINTAINER tobbenb <torbjornbrekke@gmail.com>

# User/Group Id gui app will be executed as
ENV USER_ID="99" GROUP_ID="100" APP_NAME="Citrix_Receiver" TERM="xterm" WIDTH="1280" HEIGHT="720"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install Citrix Receiver
# cd /tmp
# wget http://www.vinnymac.org/downloads/citrix/icaclient-mod-ubuntu-14-04.deb
# sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
# sudo apt-get install -f
# sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/


VOLUME ["/config"]
EXPOSE 3389 8080
