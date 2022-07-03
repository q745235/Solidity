const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");

module.exports = async function(deployer) {
  const network = deployer.network;
  console.log(`Use ${network}`);
  if(network == 'test'){

    await deployer.deploy(USDT);
  }
  await deployer.deploy(RandomNFT);
};
