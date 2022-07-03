const DutchAuction = artifacts.require("DutchAuction");

module.exports = async function (deployer, network, accounts) {
    // const dutchAuction = await DutchAuction.deployed();
    if(network == 'test'){
        await dutchAuction.setAuctionTime(
            1645275400, // 2022/2/28 0:00
            5644163140  // 3022/2/6 23:59
        );
    }else if(network == 'bscTest'){
        // await dutchAuction.setAuctionTime(
        //     1645275400, // 2022/2/28 0:00
        //     5644163140  // 3022/2/6 23:59
        // );
    }
    
};