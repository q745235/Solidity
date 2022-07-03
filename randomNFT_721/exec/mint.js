const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");
module.exports = async function (done) {
  try {
        // const randomNFT = await RandomNFT.deployed();
        const randomNFT = await RandomNFT.at("");
        const usdt = await USDT.at('');
        // await randomNFT.setNewSell(155,155,0,0,{
        //   from:""});
        // await usdt.approve(
        //   randomNFT.address, web3.utils.toWei('1000'),
        //   {from:""});
        // await randomNFT.buyRandomNFTbyUsdt({from:""});
        // await randomNFT.setNewSell(154,2,9,143,{
        //   from:""});
        console.log("owner :", await randomNFT.owner());
        console.log(await randomNFT.sellStartTime().toString());
        console.log(await randomNFT.usdtContract());
        console.log(await randomNFT.TwoWallet());
        console.log(await randomNFT.OneWallet());
        console.log(await randomNFT.ThreeWallet());
        console.log(await randomNFT.RandomNFTWallet());
        console.log(await randomNFT.tokenURI(1001));
        done()
  } catch (error) {
      console.log(error);
  }
};