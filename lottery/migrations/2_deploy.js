const Chest = artifacts.require("Chest");
const ItemCard = artifacts.require("ItemCard");
const Character = artifacts.require("Character");
const Lottery = artifacts.require("Lottery");
const USDT = artifacts.require("USDT");
const Pack = artifacts.require("ItemCardPack");

module.exports = async function (deployer) {
  const network = deployer.network;
  console.log(`Use ${network}`);
  if(network == 'test'){
    await deployer.deploy(Chest);
    await deployer.deploy(ItemCard);
    await deployer.deploy(Character);
    await deployer.deploy(USDT);
    await deployer.deploy(Pack);
  }
  await deployer.deploy(Lottery);
};