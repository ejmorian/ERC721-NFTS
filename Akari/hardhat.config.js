require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter")
require("dotenv").config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const PRIVATE_KEY_ONE = process.env.PRIVATE_KEY_ONE;
const PRIVATE_KEY_TWO = process.env.PRIVATE_KEY_TWO;
const PRIVATE_KEY_THREE = process.env.PRIVATE_KEY_THREE;
const SEPOLIA_URL = process.env.SEPOLIA_URL;
const GOERLI_URL = process.env.GOERLI_URL;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const CMC_API_KEY = process.env.CMC_API_KEY;
const POLYGON_MUMBAI = process.env.POLYGON_MUMBAI;

module.exports = {
  solidity: "0.8.18",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    },
    sepolia: {
      url: SEPOLIA_URL,
      chainId: 11155111,
      accounts: [PRIVATE_KEY, PRIVATE_KEY_ONE, PRIVATE_KEY_TWO, PRIVATE_KEY_THREE]
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/n4KWXn-Fa81seRsQd1gvU1YvwLn_gDOH",
      accounts: [PRIVATE_KEY]
    },
    polygon_mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/A45tEKEdxdTavLZLXIWRrJUD-2bMpP3p",
      accounts: [PRIVATE_KEY],
      chainId: 80001
    }
  },
  etherscan: {
    
    apiKey: POLYGON_MUMBAI,

  },
  mocha: {
    setTimeout: 100000,
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    coinmarketcap: CMC_API_KEY,
    noColors: true,
  }
};