# cluster-setup

This is to set up my home cluster

The goal is on my fresh install of my master server machine, git clone this repo
then run the master_script.sh in master_scripts folder.  This will set up my master
server as well as set up all connected minions.

It will install salt-master on the machine that runs this script as well as utilize
nmap to find connected servers and then using salt-ssh install the salt minion to
each of the found servers.  Lastly it will apply a highstate to all servers 
(even the master) and set up all machines exactly how i expect them to look.


On master server run:

`git clone --single-branch -b master-setup https://github.com/unsupo/cluster-setup.git && cd cluster-setup && sh /master_scripts/master_script.sh`

TODO  
-----
- Add gitfs to point to [my salt states](https://github.com/unsupo/cluster-setup-salt.git)
- check for existing connected minions and not create a salt-ssh roster for them in the master_script.sh