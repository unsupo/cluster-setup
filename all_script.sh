##
## This script just sets up the vagrant box how the raspbery pi is set up
## ie with user pi password raspberry which can sudo without a password
## also fixes some old ubuntu repo issues
##

sudo sed -i 's/archive.ubuntu|in.archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu/' /etc/apt/sources.list
sudo apt-get update

user=pi
password=raspberry
# quietly add a user without password
adduser --quiet --disabled-password --shell /bin/bash --home /home/$user --gecos "User" $user

# set password
echo "$user:$password" | chpasswd

# set no password for sudo
v="$user ALL=(ALL) NOPASSWD: ALL"
grep -q "^$v" /etc/sudoers || echo $v >> /etc/sudoers
