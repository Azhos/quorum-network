const Web3 = require('web3-quorum');

// replace all "..."
// define web3, abi, contract object, bytecode, account, nonce
const web3 = new Web3(new Web3.providers.HttpProvider('...'));  //http://ip:rpcport
var abiArray = [...];
var simpleContract = web3.eth.contract(abiArray);
var bytecode = "0x..." //add 0x at the beginning
const account = '0x...';
var nonce = web3.eth.getTransactionCount(account);

const contractData = {
    from: account,
    data: bytecode,
    gas: 0x47b760,
    privateFor: ["..."],    //use public key of corresponding constallation node
    nonce: '0x' + nonce
};

//contract instance
const contractInstance = simpleContract.new(123, contractData, function(e, contract) {
    if (e) console.log("err creating contract:\n", e);
    else {
        if (!contract.address) {
            console.log("txHash: " + contract.transactionHash);
            web3.eth.getTransactionReceipt(contract.transactionHash, function(e, txReceipt) {
                if (e) console.log(e);
                else console.log(txReceipt);
            });
        } else {
            console.log("Contract mined! Address: " + contract.address);
            console.log(contract);
        }
    }
});
