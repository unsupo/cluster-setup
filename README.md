# cluster-setup

This is to set up my home cluster, but also test it first with vagrant

The goal is on my fresh install of my master server machine, git clone this repo
then run the master_script.sh in master_scripts folder.  This will set up my master
server as well as set up all connected minions.

It will install salt-master on the machine that runs this script as well as utilize
nmap to find connected servers and then using salt-ssh install the salt minion to
each of the found servers.  Lastly it will apply a highstate to all servers 
(even the master) and set up all machines exactly how i expect them to look.


On master server run:

`git clone --single-branch -b master-setup https://github.com/unsupo/cluster-setup.git && \
            cd cluster-setup && sudo sh master_scripts/master_script.sh 10.0.0.0`

Completed
----
- Add gitfs to point to [my salt states](https://github.com/unsupo/cluster-setup-salt.git)


TODO  
-----
- figure a way to git clone this without taking the vagrant stuff.  
    Vagrant is good for testing (so is needed in this repo), but not every is 
    needed on real server.
    Current solution is different branch and only pull master-server branch on master server
- check for existing conected minions and not create a salt-ssh roster for them in the master_script.sh
    Currently it will add it to the roster but do nothing
