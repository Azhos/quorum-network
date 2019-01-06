#!/bin/bash
set -eu -o pipefail

GLOBAL_ARGS="--unlock 0 --password passwords.txt --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"

echo "[*] Starting Constellation node"
nohup constellation-node tm.conf 2>> qdata/logs/constellation.log &

sleep 10

echo "[*] Starting node"
PRIVATE_CONFIG=tm.conf nohup geth --datadir qdata --permissioned $GLOBAL_ARGS --raftport 23000 --rpcport 22000 --port 21000 2>>qdata/logs/1.log &

echo "[*] Waiting for nodes to start"
sleep 10

echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/geth.ipc' to attach to Geth node"
