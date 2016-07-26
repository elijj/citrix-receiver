#!/bin/bash

#apt-get update

# Install chromium browser
#sudo apt-get install -y chromium-browser

# Install ICAClient
#sudo apt-get install -f -y gdebi
#wget http://www.vinnymac.org/downloads/citrix/icaclient-mod-ubuntu-14-04.deb
#sudo dpkg -i icaclient-mod-ubuntu-14-04.deb
#sudo gdebi icaclient-mod-ubuntu-14-04.deb
#sudo apt-get -f -y install
#sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

# Set startup apps (e.g., chromium)
#cp /tmp/install/startapp.sh /startapp.sh
#chmod +x /startapp.sh

# Clean up
#sudo apt-get autoremove

# Install via mark911 instructions
cd $HOME
mv $HOME/.ICAClient $HOME/.ICAClient_save
sudo dpkg -P icaclient
rm -rf foo
sudo dpkg --add-architecture i386 # only needed once
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get --yes --force-yes install firefox apt-file git nspluginwrapper lib32z1 libc6-i386 libxml2:i386 libstdc++6:i386 libxerces-c3.1:i386 libcanberra-gtk-module:i386 libcurl3:i386 libasound2-plugins:i386 libgstreamer-plugins-base0.10-0:i386 openssl ca-certificates
sudo apt-file update --architecture i386
sudo apt-file update --architecture amd64
git clone https://github.com/CloCkWeRX/citrix-receiver-ubuntu-fixed.git foo
find foo/opt/Citrix/ICAClient/ -exec file {} ';' | grep "ELF" | grep "executable" > ica_elf_list
cat ica_elf_list | while read f; do arch=$(echo "$f" | grep -o '..-bit' | sed 's/32-bit/i386/' | sed 's/64-bit/amd64/'); file=$(echo "$f" | awk '{print $1}' | sed 's/://g'); ldd "$file" | sed "s/^/$arch/g"; done | sort | uniq > ica_so_list
cat ica_so_list | awk '{print $4}' | grep '^/' | sort | uniq | while read f; do dpkg -S "$f"; done > ica_deb_list
cat ica_deb_list | awk '{print $1}' | sed 's/:$//g' | sort | uniq > ica_deb_list_final
cat ica_so_list | grep "not found" > ica_so_missing
cat ica_so_missing | while read f; do arch=$(echo "$f" | awk '{print $1}'); file=$(echo "$f" | awk '{print $2}'); apt-file find -x "$file$" -a $arch | sed "s/: /:$arch provides /g"; done > ica_missing_packages
cat ica_missing_packages | awk '{print $3}' | sort | uniq | while read provided; do providers=$(grep "provides $provided" ica_missing_packages | awk '{print $1}'); count=$(echo $providers | wc -w); selected=$providers; if [ $count -gt 1 ]; then echo "Multiple packages can provide $provided, please select one:" >&2; select selected in $providers; do break; done < /dev/tty; echo "You selected $selected" >&2; fi; echo $selected; done > ica_selected_packages
missing=$(cat ica_selected_packages | awk '{print $1}'); sudo DEBIAN_FRONTEND=noninteractive apt-get  --yes --force-yes   install $missing
cat ica_elf_list | while read f; do arch=$(echo "$f" | grep -o '..-bit' | sed 's/32-bit/i386/' | sed 's/64-bit/amd64/'); file=$(echo "$f" | awk '{print $1}' | sed 's/://g'); ldd "$file" | sed "s/^/$arch/g"; done | sort | uniq > ica_so_list
cat ica_so_list | awk '{print $4}' | grep '^/' | sort | uniq | while read f; do dpkg -S "$f"; done > ica_deb_list
cat ica_deb_list | awk '{print $1}' | sed 's/:$//g' | sort | uniq > ica_deb_list_final
cat ica_so_list | grep "not found" > ica_so_missing
cat ica_so_missing | while read f; do arch=$(echo "$f" | awk '{print $1}'); file=$(echo "$f" | awk '{print $2}'); apt-file find -x "$file$" -a $arch | sed "s/: /:$arch provides /g"; done > ica_missing_packages
# make sure  ica_so_missing file is now empty:
cat ica_so_missing
checked=""; unnecessary=""; unchecked="$(cat ica_deb_list_final) EOF"; while read -d ' ' f <<< $unchecked; do checked="$f $checked"; candidates=$(apt-cache depends "$f" | grep '\sDepends' | awk '{print $2}' | sed 's/[<>]//g'); unchecked="$(for d in $candidates; do if ! grep -q $d <<< $checked; then echo -n "$d "; fi; done) $unchecked"; unchecked="$(echo $unchecked | sed "s/$f //g")"; unnecessary="$(for d in $candidates; do if ! grep -q $d <<< $unnecessary; then echo -n "$d "; fi; done) $unnecessary"; done; for u in $unnecessary; do echo "$u"; done > ica_implicit_dependencies
original=$(cat ica_deb_list_final); for f in $original; do if ! grep -q $f ica_implicit_dependencies; then echo "$f"; fi; done > ica_explicit_dependencies
sed -i 's/grep "i\[0-9\]86"/grep "i\\?[x0-9]86"/g' foo/DEBIAN/postinst
new_depends="$(cat ica_explicit_dependencies | tr '\n' ',') nspluginwrapper"; sed -i "s/^Depends: .*$/Depends: $new_depends/" foo/DEBIAN/control
rm -rf foo/opt/Citrix/ICAClient/keystore/cacerts
ln -s /etc/ssl/certs foo/opt/Citrix/ICAClient/keystore/cacerts
mkdir -p foo/usr/share/applications
printf '[Desktop Entry]\nName=Citrix ICA client\nComment="Launch Citrix applications from .ica files"\nCategories=Network;\nExec=/opt/Citrix/ICAClient/wfica\nTerminal=false\nType=Application\nNoDisplay=true\nMimeType=application/x-ica' > foo/usr/share/applications/wfica.desktop
dpkg -b foo icaclient_amd64_fixed_for_14.04_LTS.deb
sudo dpkg -i icaclient_amd64_fixed_for_14.04_LTS.deb
sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts
sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
xdg-mime default wfica.desktop application/x-ica
