const WhiteAuction = artifacts.require("WhiteAuction");

module.exports = async function(deployer, network, accounts) {
  let whiteAuction = await WhiteAuction.deployed();

  if(network == 'bscTest'){
    await whiteAuction.setUsdtContract('');
    await whiteAuction.setTwoWallet('');
    await whiteAuction.setOneWallet('');
  }else if (network == 'bsc'){
    await whiteAuction.setOneWallet('');
  }
};
