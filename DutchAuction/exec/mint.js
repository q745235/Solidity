const DutchAuction = artifacts.require("DutchAuction");
const Character = artifacts.require("Character");
module.exports = async function (done) {
  try {
        const dutchAuction = await DutchAuction.deployed();
        const character = await Character.deployed();

        // await dutchAuction.setUsdtContract("");
        // await dutchAuction.setTwoWallet("");
        // await dutchAuction.setOneWallet("");
        // await dutchAuction.setOneWallet('');
        // await dutchAuction.setCharacterContract('');
        // await dutchAuction.setAuctionTime(
        //   1645173000, // 2022/1/28 0:00
        //   5644163140  // 2022/2/6 23:59
        // );
        // await dutchAuction.setCharacterContract("");
        // await character.setMiner("");
        // await character.setBaseURI("https://q745235/characters/");
        // await character.setCharacterURI(105,"105.json");
        // await character.setCharacterURI(106,"106.json");
        console.log("dutchAuction owner",await dutchAuction.owner());
        // await dutchAuction.transferOwnership("")
        console.log(await dutchAuction.getTotalAuction());
        console.log(await dutchAuction.dutchAuctionTime());
        console.log(await dutchAuction.usdtContract());
        console.log(await dutchAuction.OneWallet());
        console.log(await dutchAuction.TwoWallet());
        console.log(await dutchAuction.characterContract());
        console.log(await character.characterURI(105));
        console.log("isMiner",await character.isMiner(""));
        console.log(await dutchAuction.dutchAuctionTime());
        console.log(await dutchAuction.getLowestPrice());
        console.log(await character.tokenInfo(105003));
        done()
  } catch (error) {
      console.log(error);
  }
};