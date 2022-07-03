const RandomNFT = artifacts.require("RandomNFT");

module.exports = async function(deployer, network, accounts) {
  let randomNFT = await RandomNFT.deployed();

  if(network == 'bscTest'){
    await randomNFT.setUsdtContract('');
    await randomNFT.setOneWallet('');
    await randomNFT.setTwoWallet('');
    await randomNFT.setThreeWallet('');
    await randomNFT.setRandomNFTWallet('');
  }else if (network == 'bsc'){
    await randomNFT.setWhitelist("",true);
  }
};
