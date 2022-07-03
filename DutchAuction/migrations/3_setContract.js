const DutchAuction = artifacts.require("DutchAuction");
const Character = artifacts.require("Character");
const USDT = artifacts.require("USDT");

module.exports = async function (deployer, network, accounts) {
    let characterAddr;
    let usdtAddr;

    // const dutchAuction = await DutchAuction.deployed();
    
    if(network == 'test'){
        const character = await Character.deployed();
        const usdt = await USDT.deployed();
        characterAddr = character.address;
        usdtAddr = usdt.address;
        await dutchAuction.setCharacterContract(characterAddr);
        await dutchAuction.setUsdtContract(usdtAddr);
        await character.setMiner(dutchAuction.address);
    }else if(network == 'bscTest'){
        // characterAddr = '';
        // usdtAddr = '';
        // await dutchAuction.setCharacterContract(characterAddr);
        // await dutchAuction.setUsdtContract(usdtAddr);
    }

};