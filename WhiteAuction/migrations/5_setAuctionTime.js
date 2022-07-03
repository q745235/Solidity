const WhiteAuction = artifacts.require("WhiteAuction");

module.exports = async function (deployer, network, accounts) {
    const whiteAuction = await WhiteAuction.deployed();
    if(network == 'test'){
        await whiteAuction.setAuctionTime(
            1645009200, // 2022/1/28 0:00
            5644163140  // 2022/2/6 23:59
        );
    }else if(network == 'bscTest'){
        await whiteAuction.setAuctionTime(
            1645416000, // 2022/2/21 12:00
            1645531200  // 2022/2/22 20:00
        );
        await whiteAuction.setCustomer(
            [

            ],true
        );
    }else if (network == 'bsc'){
        await whiteAuction.setCustomer([

          ],true);
          console.log("setCustomer 2");
          await whiteAuction.setCustomer([

          ],true);
    }
    
};