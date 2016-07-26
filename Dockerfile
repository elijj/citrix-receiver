FROM hurricane/dockergui:x11rdp1.3
MAINTAINER tobbenb <torbjornbrekke@gmail.com>

# User/Group Id gui app will be executed as
ENV USER_ID="99" GROUP_ID="100" APP_NAME="Citrix_Receiver" TERM="xterm" WIDTH="1280" HEIGHT="720"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install Citrix Receiver
ADD ./files/ /tmp/
RUN dpkg -i /tmp/icaclient_13.3.0.344519_amd64.deb
RUN sudo apt-get install -f -y


VOLUME ["/config"]
EXPOSE 3389 8080
