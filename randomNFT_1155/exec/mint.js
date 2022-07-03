const RandomNFT = artifacts.require("RandomNFT");
module.exports = async function (done) {
  try {
        // const randomNFT = await RandomNFT.deployed();
        const randomNFT = await RandomNFT.at("");
        // await randomNFT.setWhitelist("",true);
        // await randomNFT.setPriceForUSDT(web3.utils.toWei('0.00001'));
        // await randomNFT.setChipsPurchaseTime(	
        //   1650585600,
        //   3670024000
        //   );
        // await randomNFT.setNewPermitSell(2,1,1);
        // await randomNFT.setWhitelist('',true);
        console.log("owner :", await randomNFT.owner());
        // await randomNFT.transferOwnership("");
        console.log(await randomNFT.name());
        console.log(await randomNFT.symbol());
        console.log("chipsPurchaseTime",(await randomNFT.chipsPurchaseTime()).toString());
        console.log("chipsPurchaseEnd",(await randomNFT.chipsPurchaseEnd()).toString());
        console.log("usdt",await randomNFT.usdtContract());
        console.log("One",await randomNFT.OneWallet());
        console.log("Two",await randomNFT.TwoWallet());
        console.log("Three",await randomNFT.ThreeWallet());
        console.log("RandomNFT",await randomNFT.RandomNFTWallet());
        console.log(await randomNFT.tokenURI(1));
        console.log(await randomNFT.tokenURI(2));
        console.log(web3.utils.fromWei(await randomNFT.getPriceForUSDT()));
        console.log("permitSellAmount",(await randomNFT.permitSellAmount()).toString());
        console.log("jpgChips",(await randomNFT.jpgChips()).toString());
        console.log("gifChips",(await randomNFT.gifChips()).toString());
        console.log("limit",(await randomNFT.limit()).toString());
        console.log("isWhitelist",await randomNFT.isWhitelist(''));
        console.log(await randomNFT.balanceOf('',1));

        done()
  } catch (error) {
      console.log(error);
  }
};