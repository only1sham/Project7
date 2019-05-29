const HDWallet = require('truffle-hdwallet-provider');
const infuraKey = "17c9794557924b5b8bb9de154f6f04b3";

const mnemonic = "velvet special inform where pluck chalk agree moon father emerge now moment";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
	rinkeby: {
      provider: () => new HDWallet(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`),
      network_id: 4,       // Rinkeby's id
      gas: 4500000,        // Rinkeby has a lower block limit than mainnet
      gasPrice: 10000000000
    },
  }
};