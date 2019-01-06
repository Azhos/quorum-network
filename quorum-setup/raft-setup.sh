#!/bin/bash
set -eu -o pipefail

CONSTELLATION_KEY_PASSWORD=""

echo "[*] Cleaning up temporary data directories"
rm -rf raft
mkdir raft

echo "[*] Generating geth node config"
nohup geth --datadir raft 2>> raft/setup.log &
sleep 3
# server ip address
IP_ADDRESS="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
# generate own enode with server ip address
echo "[\"$(cat raft/setup.log | grep -oEi '(enode.*@)')$IP_ADDRESS:21000?discport=0&raftport=23000\"]" >> raft/own_enode.json

echo "[*] Creating default ethereum account"
geth --datadir raft --password passwords.txt account new

echo "[*] Generating constellation key pair"
cd raft
echo $CONSTELLATION_KEY_PASSWORD | constellation-node --generatekeys=tm

echo "[*] Done"
