const Surprise = artifacts.require("Surprise");

module.exports = async function(deployer, network, accounts) {
  let surprise = await Surprise.deployed();

  if(network == 'test'){
    await surprise.setSellTime(1643004800,8643990400);
  }else if(network == 'bsc'){
    await surprise.setOneWallet("");
    await surprise.setTwoWallet("");
    await surprise.setThreeWallet("");
  }
};
