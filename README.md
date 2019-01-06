# Quorum Network

### Setup nodes on multiple servers (Digital Ocean Droplets) 

Log into your Digital Ocean account (https://cloud.digitalocean.com/droplets/new) and create at least 3 droplets, better 4-5. The distribution on each of them should be `Ubuntu 16.04.5 x64` and if you use standard droplets, choose at least `2GB Memory / 1CPU / 50GB Disk` for $10/mo/droplet.

Log into each of the created droplets via ssh and configure a new user:

```shell
ssh root@<droplet_ip>
useradd -m username
passwd username
usermod -a -G sudo name
```

Go into your home or working directory, clone the `/Azhos/quorum-network` repository and copy all setup scripts and misc files into your working directory:

```shell
cd ~
git clone https://github.com/Azhos/quorum-network.git
cp quorum-network/quorum-setup/* .
cp quorum-network/misc/* .
```

All shell scripts are based on the official [7nodes](https://github.com/jpmorganchase/quorum-examples/tree/master/examples/7nodes) example, but are adapted to facilitate the installation on servers instead of using a vagrant environment. All scripts are updated to the latest versions and behaviors of Quorum, Constellation etc. 

#### 1. Update the system, setup Quorum, Constellation, Go and build dependencies: 

```shell
sudo chmod +x *.sh
sudo ./bootstrap.sh
```

#### 2. Creating enodes, Ethereum accounts and constellation key pair:

```bash
sudo ./raft-setup.sh
```

**!** Before we move on, repeat step **(1)** and **(2)** for every server in your cluster **!**

After step (1) and (2) have been performed on each server, do the following: 

- Copy the address of each required Ethereum account into the `genesis.json` (to pre-fund accounts) 
- Copy all node identifiers (enodes) into the `static-nodes.json` (to specify a list of static nodes the client should always connect to) 
- Edit the transaction manager's configuration file `tm.conf` for the constellation node (responsible for transaction privacy)

Then go on with step **(3)**.

**Copy the address of each required Ethereum account into the genesis.json**: 

The addresses values can be found within the files in keystore folder `raft/keystore/<file>`. You can output the content of the files as follows:

```shell
sudo cat raft/keystore/$(sudo ls raft/keystore/) 
```

The first key-value-pair is relevant `"address":"<example_address_value>"`. Add it (prefixed with a `0x`) to the `alloc` section of the `genesis.json`. 

Example:

`"address":"1e6c0cb9f6b7e628feab2cefc51f825125fe0940"`

`"address":"b114c9be6127413b6cedbc244d1823e05060d5dc"`

```json
"alloc": {
    "0x1e6c0cb9f6b7e628feab2cefc51f825125fe0940": {
        "balance": "1000000000000000000000000000"
    },
    "0xb114c9be6127413b6cedbc244d1823e05060d5dc": {
        "balance": "1000000000000000000000000000"    
    },
    //...
}
```

This genesis file needs to be the same across all the nodes in the cluster and has to be located in the working directory.

**Copy all node identifiers (enodes) into the static-nodes.json**: 

The enodes can be found here `raft/own_enode.json`. Add the `enodes` of each server to the `static-nodes.json` file and move it into the `raft` folder. 

Example:

```json
[
"enode://c3288dcc8e72a616848bb8444e3c9b2e17abb162b427155bef07843da9d54dab39eecc7ba9c8d0d0f17aa5cf8cf28a222aef4d63c1f479e17a7370748f12f139@server_ip:21000?discport=0&raftport=23000",
"enode://38195ae586c63126cd8e0a085a118f8398d9f898a8bece3a4059d7d0ca03580e00c33a4a0d0bf0c8b82e30b82af4a58d5f182688280d6e942e8415e106f81e57@server_ip:21000?discport=0&raftport=23000",
//...
]
```

The file should be identical across all the nodes in the cluster.

**Edit the transaction manager's configuration file tm.conf for the constellation node:**

Within the `tm.conf` file configure the `url` field (own public ip) and the `othernodes` field (public ips of all other nodes in the cluster) , so that each node has the public ip and port of its own and all the other nodes in the cluster.

#### 3. Initialize keystores, nodekey, static-nodes, permissioned-nodes, genesis

```shell
sudo ./raft-init.sh
```

#### 4. Start constellation nodes and quorum nodes

```bash
sudo ./raft-start.sh
```

#### 5. Stop

```shell
sudo ./raft-stop.sh
```

When something goes wrong or serious errors occur, delete and re-initialize the chain data by doing step **(3)** and **(4)**.
