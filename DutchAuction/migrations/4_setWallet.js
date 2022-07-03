const DutchAuction = artifacts.require("DutchAuction");

module.exports = async function(deployer, network, accounts) {
  let dutchAuction = await DutchAuction.deployed();

  if(network == 'bscTest'){
    // await dutchAuction.setUsdtContract('');
    // await dutchAuction.setTwoWallet('');
    // await dutchAuction.setOneWallet('');
  }else if (network == 'bsc'){
    await dutchAuction.setOneWallet('');
    await dutchAuction.setCharacterContract('');
  }
};
