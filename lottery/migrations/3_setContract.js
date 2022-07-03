const Lottery = artifacts.require("Lottery");
const ItemCard = artifacts.require("ItemCard");
const Character = artifacts.require("Character");
const Chest = artifacts.require("Chest");
const USDT = artifacts.require("USDT");
const Pack = artifacts.require("ItemCardPack");

module.exports = async function (deployer, network, accounts) {
    let itemAddr;
    let characterAddr;
    let chestAddr;
    let usdtAddr;
    let packAddr;

    const lottery = await Lottery.deployed();
    
    if(network == 'test'){
        const item = await ItemCard.deployed();
        const character = await Character.deployed();
        const chest = await Chest.deployed();
        const usdt = await USDT.deployed();
        const pack = await Pack.deployed();
        itemAddr = item.address;
        characterAddr = character.address;
        chestAddr = chest.address;
        usdtAddr = usdt.address;
        packAddr = pack.address;
    }else if(network == 'bscTest'){
        itemAddr = '';
        characterAddr = '';
        chestAddr = '';
        usdtAddr = '';
        packAddr = '';
    }else if(network == 'bsc'){
        itemAddr = '';
        characterAddr = '';
        chestAddr = '';
        usdtAddr = '';
        packAddr = '';
    }

    await lottery.setCharacterContract(characterAddr);
    await lottery.setChestContract(chestAddr);
    await lottery.setItemContract(itemAddr);
    await lottery.setUsdtContract(usdtAddr);
    await lottery.setPackContract(packAddr);
};