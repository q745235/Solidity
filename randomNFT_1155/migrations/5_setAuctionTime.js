const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");
module.exports = async function (deployer, network, accounts) {
    const randomNFT = await RandomNFT.deployed();
    // await randomNFT.setJpgChips(990);
    // await randomNFT.setGifChips(10);
    // await randomNFT.setBaseURI('https://q745235/randomNFT/1155');
    // await randomNFT.setChestURI(1, '1.json');
    // await randomNFT.setChestURI(2, '2.json');
    if(network == 'test'){
        await randomNFT.setChipsPurchaseTime(
            164525400, // 2022/2/28 0:00
            5644163140  // 3022/2/6 23:59
        );
    }else if(network == 'bscTest'){
        // const usdt = await USDT.at('');
        // await usdt.approve(randomNFT.address,10 ** 22);
        // await randomNFT.setAuctionTime(
        //     1645275400, // 2022/2/28 0:00
        //     5644163140  // 3022/2/6 23:59
        // );
    }
    
};