const Lottery = artifacts.require("Lottery");

module.exports = async function (done) {
  try {
        const lottery = await Lottery.deployed();
        // await lottery.setLotterySellTime(1637737600, 1637837600);
        // let r = await lottery.getLotteryPriceForUSDT();
        // console.log(r);
        await lottery.setTokenId(0, 201221);
        await lottery.setTokenId(1, 202376);
        await lottery.setTokenId(2, 203338);
        await lottery.setTokenId(3, 2006725);
        await lottery.setTokenId(4, 11778);
        await lottery.setTokenId(5, 11779);
        await lottery.setTokenId(6, 11780);
        await lottery.setTokenId(7, 11781);
        await lottery.setTokenId(8, 11782);
        await lottery.setTokenId(9, 11783);
        await lottery.setTokenId(10, 11784);
        await lottery.setTokenId(11, 11785);
        await lottery.setTokenId(12, 11786);
        await lottery.setTokenId(13, 11787);
        await lottery.setTokenId(14, 1065);//super
        await lottery.setTokenId(15, 1064);
        await lottery.setTokenId(16, 1063);
        await lottery.setTokenId(17, 1062);
        await lottery.setTokenId(18, 1132);
        await lottery.setTokenId(19, 1128);
        await lottery.setTokenId(20, 1127);
        await lottery.setTokenId(21, 1133);
        await lottery.setTokenId(22, 1125);
        await lottery.setTokenId(23, 1126);
        done()
  } catch (error) {
      console.log(error);
  }
};