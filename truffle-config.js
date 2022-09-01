const {mnemonic1,mnemonic,RPC } = require("./secrets.json");
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      gas: 6721975
    },
    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    testnet: {
      provider: () => new HDWalletProvider(mnemonic1,RPC),
      network_id: 4,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed1.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
   },
   compilers: {
    solc: {
      version: "^0.6.0"
    }
  }
 };
