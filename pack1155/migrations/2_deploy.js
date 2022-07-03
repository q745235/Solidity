const Chest = artifacts.require("Chest");
const ItemCard = artifacts.require("ItemCard");

module.exports = function (deployer) {
  if(deployer.network == 'test'){
    deployer.deploy(Chest);
    deployer.deploy(ItemCard);
  }else {
    deployer.deploy(Chest);
  }
};