# Useful commands for configuring a server for Nexus

# update apt
apt update

# install java 8 and net tools
apt install openjdk-8-jre-headless
apt install net-tools

# download nexus
cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
# unpack tar file
tar -zxvf latest-unix.tar.gz

# add new nexus user
adduser nexus

# give ownership of nexus directories to the new user
chown -R nexus:nexus nexus-3.28.1-01
chown -R nexus:nexus sonatype-work

# configure nexus service to run as the nexus user
vim nexus-3.28.1-01/bin/nexus.rc
# set run_as_user="nexus"

# switch to nexus user and start nexus service
su - nexus
/opt/nexus-3.28.1-01/bin/nexus start

# check for the running process and see the ports
# get netstat from installing net-tools
ps aux | grep nexus
netstat -lnpt