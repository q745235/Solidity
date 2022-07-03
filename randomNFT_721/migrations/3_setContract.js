const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");

module.exports = async function (deployer, network, accounts) {
    let usdtAddr;

    const randomNFT = await RandomNFT.deployed();
    
    if(network == 'test'){
        const usdt = await USDT.deployed();
        usdtAddr = usdt.address;
        await randomNFT.setUsdtContract(usdtAddr);
    }else if(network == 'bscTest'){

    }

};