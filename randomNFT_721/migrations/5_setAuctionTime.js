const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");
module.exports = async function (deployer, network, accounts) {
    const randomNFT = await RandomNFT.deployed();
    // await randomNFT.setBaseURI('https://q745235/randomNFT/');
    if(network == 'test'){
        await randomNFT.setChipsPurchaseTime(
            1648731600, // 2022/3/31 21:00
            5644163140  // 2023/2/6 23:59
        );
    }else if(network == 'bscTest'){
        // const usdt = await USDT.at('');
        // await usdt.approve(randomNFT.address,10 ** 22);
        // await randomNFT.setAuctionTime(
        //     1646175400, // 2022/2/28 0:00
        //     5647163140  // 2022/3/6 23:59
        // );
    }
    
};