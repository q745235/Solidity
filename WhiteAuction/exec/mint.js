const WhiteAuction = artifacts.require("WhiteAuction");
const Character = artifacts.require("Character");
module.exports = async function (done) {
  try {
        const whiteAuction = await WhiteAuction.at('');
        const character = await Character.at('');
        let whitelist = [
        
      ];
        // await whiteAuction.setCustomer([
       
        // ],true);
        console.log("setCustomer 1"); 
        // await whiteAuction.setCustomer(whitelist,true);
        // await whiteAuction.setCustomer([
        
        //   ],true);
        // console.log("setCustomer 2");
        // await whiteAuction.setCustomer([
  
        // ],true);
        // await whiteAuction.setAuctionTime(
        //   1645428300, // 2022/2/21 15:20
        //   1645531200  // 2022/2/22 20:00
        // );
        // await whiteAuction.setPriceForUSDT(10 ** 15);
        let Price = Number((await whiteAuction.getPriceForUSDT()).toString());
        console.log(Price/(10 ** 18));
        console.log("usdtContract ",await whiteAuction.usdtContract());
        console.log("OneWallet ",await whiteAuction.OneWallet());
        console.log("TwoWallet ",await whiteAuction.TwoWallet());
        console.log("characterContract ",await whiteAuction.characterContract());
        console.log((await whiteAuction.auctionStartTime()).toString());
        console.log((await whiteAuction.auctionEndTime()).toString());
        console.log(await character.characterURI(105));
        console.log(
          "",
          " isMiner",
          await character.isMiner("")
          );
        console.log("isCustomer");
        for(let i = 0; i< whitelist.length; i++ ){
          console.log(i,await whiteAuction.isCustomer(whitelist[i]));
        }
        done()
  } catch (error) {
      console.log(error);
  }
};