FROM hurricane/dockergui:x11rdp1.3
MAINTAINER tobbenb <torbjornbrekke@gmail.com>

# User/Group Id gui app will be executed as
ENV USER_ID="99" GROUP_ID="100" APP_NAME="Citrix_Receiver" TERM="xterm" WIDTH="1280" HEIGHT="720"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install Citrix Receiver
ADD ./files/ /tmp/
RUN sudo apt-get update
RUN sudo apt-get -y install libgtk2.0-0 libwebkit-1.0-2
RUN dpkg -i /tmp/icaclient_13.3.0.344519_amd64.deb


VOLUME ["/config"]
EXPOSE 3389 8080
