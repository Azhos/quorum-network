#!/bin/bash
set -eu -o pipefail

# set locales before update && upgrade
#sudo -i
#locale
#export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8
#dpkg-reconfigure locales
#reboot

# update system (with bypass apt prompt and grub conf override question)
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get -y upgrade

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk software-properties-common default-jdk maven

# install constellation
CVER="0.3.2"                                # <-- check update!
CREL="constellation-$CVER-ubuntu1604"
wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
tar xfJ $CREL.tar.xz
cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf $CREL

# install golang
GOREL=go1.10.6.linux-amd64.tar.gz           # <-- check update!
# go1.11.3.linux-amd64.tar.gz               # v1.11.3 fails on "make all"        
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
#echo 'PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc
echo 'PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# make/install quorum
git clone https://github.com/jpmorganchase/quorum.git
pushd quorum >/dev/null
git checkout tags/v2.2.0                    # <-- check update!
make all
cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null

# done!
banner "Quorum"
