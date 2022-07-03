const WhiteAuction = artifacts.require("WhiteAuction");
const USDT = artifacts.require("USDT");
const Character = artifacts.require("Character");
module.exports = async function(deployer) {
  const network = deployer.network;
  console.log(`Use ${network}`);
  if(network == 'test'){
    await deployer.deploy(Character);
    await deployer.deploy(USDT);
  }
  // await deployer.deploy(Character);
  await deployer.deploy(WhiteAuction);
};
