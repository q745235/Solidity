const WhiteAuction = artifacts.require("WhiteAuction");
const Character = artifacts.require("Character");
const USDT = artifacts.require("USDT");

module.exports = async function (deployer, network, accounts) {
    let characterAddr;
    let usdtAddr;

    const whiteAuction = await WhiteAuction.deployed();
    
    if(network == 'test'){
        
        const usdt = await USDT.deployed();
        characterAddr = character.address;
        usdtAddr = usdt.address;
        await whiteAuction.setCharacterContract(characterAddr);
        await whiteAuction.setUsdtContract(usdtAddr);
        await character.setMiner(whiteAuction.address);
    }else if(network == 'bscTest'){
        characterAddr = '';
        usdtAddr = '';
        await whiteAuction.setCharacterContract(characterAddr);
        await whiteAuction.setUsdtContract(usdtAddr);
        const character = await Character.at('');
        await character.setMiner(whiteAuction.address);
    }else if(network == 'bsc'){
        characterAddr = '';
        await whiteAuction.setCharacterContract(characterAddr);
        const character = await Character.at('')
        await character.setMiner(whiteAuction.address);
    }

};