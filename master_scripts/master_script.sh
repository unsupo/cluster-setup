##
## This script sets up a master node and installs salt master and minion.
## Then it using nmap to find other connected hosts and sets up a salt-ssh
## roster file for them.  Then it uses salt-ssh to apply the minion state
## which installs the salt minion on each host found.  Lastly it accepts
## the found minion keys
##
## In vagrant this is used to test the script, but isn't needed to set up
## a group of machines like this, instead you can use the all_script.sh
## to simply set up all machines.  However i use this vagrant set up to
## test the script.
##
## goal do salt from gitfs
## Ideally log into master run git clone https://github.com/unsupo/cluster-setup.git
## which would just have this script and master_overrides.conf
## Then this script would set everything else up calling the salt states
## from gitfs using another repo https://github.com/unsupo/cluster-setup-salt.git

# install salt-master
if [ ! -e 'install_salt.sh' ]; then
    # move the master_overrides.conf to /etc/salt/master.d/
    mkdir -p /etc/salt/master.d
    mv ./master.d/master_overrides.conf /etc/salt/master.d/master_overrides.conf

  curl -L https://bootstrap.saltstack.com -o install_salt.sh
  sudo sh install_salt.sh -P -M
  if [ "$?" -ne 0 ]; then
    sudo apt-get install python-tornado -y
    sudo sh install_salt.sh -P -M
  fi

  # The following for gitfs setup
  apt-get install python-pygit2 -y
  apt-get install salt-ssh -y
fi

iprange=$1
# provision salt-ssh using nmap to get ip
myips=`hostname -I`
foundips=`nmap -sn -T5 $iprange/24 -oG - | awk '/Up$/{print $2}'`
name=raspbery-pi
k=0
f=test.file
kdir=/etc/salt/pki/master/ssh/
rfile="$kdir/salt-ssh.rsa"
mkdir -p $kdir
test -e $rfile || yes no | ssh-keygen -t rsa -f $rfile -N ''
kfile="$rfile.pub"
echo "
#!/bin/sh
echo 'raspberry'
" > t
chmod +x ./t
rm -f $f
# TODO check for existing conected minions and not create a salt-ssh roster for them
for i in $foundips; do
  t=0
  for j in $myips; do
    if [ "$i" == "$j" ]; then
      t=1
    fi
  done
  if [ "$t" -eq 1 ]; then continue; fi
  if [ ! -f /root/.ssh/known_hosts ]; then
    mkdir /root/.ssh;
    chmod 0700 .ssh
    touch /root/.ssh/known_hosts
  fi
  ssh-keyscan -t rsa,dsa $i 2>&1 | sort -u - /root/.ssh/known_hosts > /root/.ssh/tmp_hosts
  mv /root/.ssh/tmp_hosts /root/.ssh/known_hosts
  export DISPLAY=:0; SSH_ASKPASS='./t' setsid -w timeout 5 ssh-copy-id -i $kfile pi@$i
  if [ "$?" -ne 0 ]; then continue; fi
  echo "
$name-$k:
  host: $i
  user: pi
  passwd: raspbery
  sudo: True
  priv: $rfile
" >> $f
  k=$(($k+1))
done
rm -f ./t
# now all hosts have been found cat test.file into /etc/salt/roster
mv $f /etc/salt/roster

# all hosts exist in salt-ssh, so install the salt-minion on them and set up there minion id
# salt-ssh -i
# can't ssh-salt '*' state.apply salt.minion because https://github.com/saltstack/salt/issues/21370
salt-ssh '*' state.apply salt-bootstraper.minion

# salt-key -A -y
salt-key -A -y

# lastly apply a highstate to accepted minions, this should set everything else up
# from remaining master setup to remaining minions setups
salt '*' state.highstate
