# Script para configuração da Workstations
# Criado por Raphael Maria
# Versão 1.0


# Atualização de OS
#yum install epel-release -y
#rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
#yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#yum check-update
#yum update -y

# Pacotes iniciais
yum remove cloud-init -y
yum install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -y
yum -y install gcc unzip wget mesa-libGL mesa-libGL-devel ntfs-3g.x86_64 nss dkms git dnf snapd vim ansible libselinux-python vlc smplayer ffmpeg HandBrake-{gui,cli} libdvdcss gstreamer{,1}-plugins-ugly gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad-freeworld libde265 x265


rpm -aq | grep teamviewer
rpm -e teamviewer-*
rm -rf /etc/teamviewer
## rpm --import http://download.teamviewer.com/download/TeamViewer_Linux_PubKey.asc
yum install http://192.168.8.7/app/teamviewer_12.0.137452.i686.rpm -y
#yum install http://download.teamviewer.com/download/teamviewer.i686.rpm -y
systemctl enable teamviewerd.service
systemctl start teamviewerd.service

#remover Kernels Antigos
package-cleanup --oldkernels --count=2

#Install 10 Gigabit Versão Uira
scp -r root@192.168.8.7:/Storage/Install/Linux/Drivers/Rede/Startech/Tehuti_TN4010_Linux-ESXI_PCIe_10_Gigabit_Network_Card .
cd Tehuti_TN4010_Linux-ESXI_PCIe_10_Gigabit_Network_Card/Linux
make install

# Install 10 Gigabit Versão Rafael Fuzarri
wget http://install.o2pos.com/app/tn40xx-0.3.6.17.zip
unzip tn40xx-0.3.6.17.zip
cd tn40xx-0.3.6.17.2
make && sudo make install


#wget http://download1.rpmfusion.org/free/el/updates/testing/7/x86_64/
#rpm -Uvh rpmfusion-free-release*rpm
#yum install x264-libs

mdadm -E /dev/sd[b-e]
mdadm --create /dev/md127 --level=raid0 --raid-devices 4 /dev/sd[b-e]1 

# RAID 5
mdadm -C /dev/md0 -l=5 -n=4 /dev/sd[b-e]1

mkfs.ext4 --force /dev/md0

# Driver Video com RUN DA NVIDIA
init 2
yum remove xorg-x11-drivers xorg-x11-drv-nouveau -y
yum remove kmod-nvidia
rpm -e kmod-nvidia
wget http://192.168.8.7/app/NVIDIA-Linux-390.87.zip
OU
wget http://192.168.8.7/app/NVIDIA-Linux-430.14.zip

unzip NVIDIA-Linux-*.*zip
chmod 777 NVIDIA-*
./NVIDIA-Linux-*.*.run -a
init 6

# Driver de video com YUM Repositorys 
init 2
yum -y install xorg-x11-drivers xorg-x11-drv-nouveau
yum -y install kmod-nvidia


# Interface Install
yum grouplist
yum groupremove "GNOME Desktop" -y
systemctl set-default graphical.target
systemctl start graphical.target



#Install Neat Video Plugin
scp root@192.168.8.7:/Storage/Install/Linux/Softwares/Neatvideo/NeatVideo4OFX.Pro.Intel64.run .
bash NeatVideo4OFX.Pro.Intel64.run

scp -r root@192.168.8.11:/Storage/Homes/skeleton /tmp
mv /tmp/skeleton/* /etc/skel
chmod -R 777 /etc/skel/*

#######################
## Set Name Hostname ##
#######################
hostnamectl set-hostname queues.o2pos.com.br
sed -i 's/^Domain = localdomain/Domain = o2pos.com/' /etc/idmapd.conf

#############################################
#####      Configurando Diretorios      #####
#############################################
cp -b /etc/fstab /root/backups/fstab.bkps
ln -s /mnt /Volumes
ln -s /mnt/cache /mnt/Cache_Nuke
ln -s /mnt/cache /mnt/cache_nuke
umount -a
mkdir /mnt/RRender
chmod 777 /mnt/RRender
mkdir /mnt/Library
chmod 777 /mnt/Library
mkdir /mnt/Library2
chmod 777 /mnt/Library2
mkdir /mnt/RAW1
chmod 777 /mnt/RAW1
mkdir /mnt/RAW2
chmod 777 /mnt/RAW2
mkdir /mnt/RAW3
chmod 777 /mnt/RAW3
mkdir /mnt/RAWADV
chmod 777 /mnt/RAWADV
mkdir /mnt/Publicidade
chmod 777 /mnt/Publicidade
mkdir /mnt/Entretenimento
chmod 777 /mnt/Entretenimento
mkdir /mnt/Entretenimento2
chmod 777 /mnt/Entretenimento2
mkdir /mnt/Entretenimento3
chmod 777 /mnt/Entretenimento3
mkdir /mnt/Entretenimento4
chmod 777 /mnt/Entretenimento4
mkdir /mnt/Onix
chmod 777 /mnt/Onix
mkdir /mnt/Install
chmod 777 /mnt/Install
mkdir /mnt/opt2
chmod 777 /mnt/opt2
mkdir /mnt/oldhomes
chmod 777 /mnt/oldhomes
mkdir /mnt/cache
chmod -R 777 /mnt/cache
mkdir /mnt/raid
chmod -R 777 /mnt/raid
chmod -R 777 /mnt/cache_nuke
chmod -R 777 /mnt/Cache_Nuke


#####################
#### PROGRAMAS ######
#####################
rm -rf /usr/local/foundry/RLM
#rm -rf /etc/launchd.conf 
#echo "setenv NUKE_PATH /Volumes/Onix/.Nuke" >> /etc/launchd.conf 
#/opt/o2app/1_Exec_como_root_o2_app_handler.sh
rm -rf /opt/scripts/WacomPressureBug.sh
wget https://play.o2filmes.com/pauta/app/lnx/pauta_bridge_install.sh
chmod +X pauta_bridge_install.sh
chmod 777 pauta_bridge_install.sh
bash pauta_bridge_install.sh
rm -rf pauta_bridge_install.sh
/opt/hfs17.5/bin/hkey

#Acertos
echo "O servidor é 192.168.8.63"

# Instalando VNC SERVER 
yum install tigervnc-server xorg-x11-fonts-Type1 -y
cp /lib/systemd/system/vncserver@.service  /etc/systemd/system/vncserver@:1.service
vi /etc/systemd/system/vncserver@\:1.service
systemctl daemon-reload
systemctl start vncserver@:1
systemctl status vncserver@:1
systemctl enable vncserver@:1
echo "Insira a senha para acesso"
vncserver


/etc/init.d/rrAutostart restart

#Placa de rede
# Configuração de IP com Network Manager
nmcli con show
# Linha para comando de IP FIXO
nmcli con modify ens3 ipv4.method manual ipv4.addresses 192.168.7.31/16 ipv4.gateway 192.168.8.1 ipv4.dns 192.168.8.15,192.168.8.16 ipv4.dns-search o2pos.com.br
# Linha para comando para o DNS FIXO APENAS
nmcli connection modify p8p1 ipv4.ignore-auto-dns yes ipv4.dns 192.168.8.100,192.168.8.115 ipv4.dns-search o2pos.com.br
nmcli con up p8p1

sudo hostnamectl set-hostname render25.o2pos.com




mv /etc/resolv.conf /etc/resolv.conf.old
echo "name server = 192.168.8.100
name server = 192.168.8.110" >> /etc/resolv.conf

 
yum install ipa-client -y
ipa-client-install --mkhomedir --no-ntpd

nmcli con mod ens3 ipv4.ignore-auto-dns yes ipv4.dns 192.168.8.100,192.168.8.110 ipv4.dns-search o2pos.com.br
/opt/hfs17.5/bin/hkey

reboot



rpm -ivh [pacote]


# Instanado o Royal Render
echo "Configuração terminada com sucesso"




sudo echo "setenv NUKE_PATH /Volumes/Onix/.Nuke" >> /etc/launchd.conf 
sudo echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
  <plist version=\"1.0\">
  <dict>
  <key>Label</key>
  <string>setenv.NUKE_PATH</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/launchctl</string>
    <string>setenv</string>
    <string>NUKE_PATH</string>
    <string>/Volumes/Onix/.Nuke</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>ServiceIPC</key>
  <false/>
</dict>
</plist>" >> /Library/LaunchAgents/setenv.Nuke.plist

sudo chown root  /Library/LaunchAgents/setenv.Nuke.plist



na pasta /cron.hourly
gcds

# Install Cinnamon Desktop View
yum -y install epel-release
yum -y groupinstall "X Window system"
yum -y install lightdm
yum -y install cinnamon


# Download Nuke
LINUX
http://thefoundry.s3.amazonaws.com/products/nuke/releases/10.5v5/Nuke10.5v5-linux-x86-release-64.tgz
MAC
http://thefoundry.s3.amazonaws.com/products/nuke/releases/10.0v3/Nuke10.0v3-mac-x86-release-64.dmg


http://thefoundry.s3.amazonaws.com/products/hieroplayer/releases/1.9v1/HieroPlayer1.9v1-mac-x86-release-64.dmg

http://thefoundry.s3.amazonaws.com/products/hieroplayer/releases/11.0v1/HieroPlayer11.0v1-mac-x86-release-64.dmg

# Variable Nuke Path Linux
Criar o arquivo em:

echo "export NUKE_PATH=/mnt/Onix/.Nuke" >> /etc/profile.d/onix.sh



http://thefoundry.s3.amazonaws.com/products/Hiero/releases/11.0v0/Hiero11.0v0-mac-x86-release-64.dmg



Hiero 11.0v2 User Guide - AWS
https://thefoundry.s3.amazonaws.com/products/nuke/.../11.../Hiero11.0v2_UserGuide.p...

https://thefoundry.s3.amazonaws.com/products/nuke/releases/11.0v2/Hiero11.0v2-mac-x86-release-64.dmg


