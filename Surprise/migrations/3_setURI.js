const Surprise = artifacts.require("Surprise");

module.exports = async function(deployer, network, accounts) {
  let surprise = await Surprise.deployed();
  await surprise.setBaseURI("https://q745235/");
  await surprise.setSurpriseIndexURI(1,"1.json");
  await surprise.setSurpriseIndexURI(2,"2.json");
  if(network == 'bsc'){
    await surprise.setLuckyTime(1646409600);
  }
};
