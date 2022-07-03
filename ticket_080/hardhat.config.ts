import dotenv from "dotenv";
import { HardhatUserConfig, task } from "hardhat/config";
import "hardhat-jest-plugin";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

if (process.env.REPORT_GAS) {
  require("hardhat-gas-reporter");
}

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async(taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
      console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  networks: {
    hardhat: {},
    ropsten: {
      url: "",
      accounts:[process.env.PRIVATEKEY],
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org",
      accounts: [process.env.PRIVATEKEY],
      chainId: 56,
    },
    bsctest: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      // accounts: {
      //   mnemonic: process.env.MNEMONIC,
      // },
      accounts: [process.env.PRIVATEKEY],
      chainId: 97,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      }
    ],
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      bsc: "YNGXNGBEMDKWGZGA1P81NRJEBSXTGTRXBH",
      bscTestnet: "YNGXNGBEMDKWGZGA1P81NRJEBSXTGTRXBH",
      heco: "X9DKGMW3V7KZ278FJ2J9BPK7Q4YNAJDUX8"
    }
  },
};

export default config;
