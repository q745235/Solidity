const Lottery = artifacts.require("Lottery");

module.exports = async function (deployer, network, accounts) {
    const lottery = await Lottery.deployed();
    await lottery.setLotterySellTime(
        1643299200, // 2022/1/28 0:00
        1644163140  // 2022/2/6 23:59
    );
};