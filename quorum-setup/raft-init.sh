#!/bin/bash
set -eu -o pipefail

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node"                       
mkdir -p qdata/{keystore,geth}
cp raft/static-nodes.json qdata
cp raft/static-nodes.json qdata/permissioned-nodes.json
cp raft/keystore/$(ls raft/keystore) qdata/keystore/acckey
cp raft/geth/nodekey qdata/geth/nodekey
geth --datadir qdata init genesis.json
