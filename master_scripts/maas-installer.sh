sudo apt-get update \
  && sudo apt install maas \
  && sudo maas init \
  && sudo maas createadmin --username unsupo --password password --email unsupo@gmail.com

sudo apt-add-repository ppa:conjure-up/next \
  && sudo apt-add-repository ppa:juju/devel \
  && sudo apt-get update \
  && sudo snap install conjure-up --classic
