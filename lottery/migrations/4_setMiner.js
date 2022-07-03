const Chest = artifacts.require("Chest");
const ItemCard = artifacts.require("ItemCard");
const Character = artifacts.require("Character");
const Lottery = artifacts.require("Lottery");
const USDT = artifacts.require("USDT");
const Pack = artifacts.require("ItemCardPack");

module.exports = async function (deployer, network, accounts) {
    let item;
    let character;
    let chest;
    let usdt;
    let pack;

    const lottery = await Lottery.deployed();
    
    if(network == 'test'){
        item = await ItemCard.deployed();
        character = await Character.deployed();
        chest = await Chest.deployed();
        usdt = await USDT.deployed();
        pack = await Pack.deployed();
        await chest.setMiner(lottery.address);
        await item.setMiner(lottery.address);
        await character.setMiner(lottery.address);
    }else if(network == 'bscTest'){
        item = await ItemCard.at('');
        character = await Character.at('');
        chest = await Chest.at('');
        usdt = await USDT.at('');
        pack = await Pack.at('');
    }else if(network == 'bsc'){
        item = await ItemCard.at('');
        character = await Character.at('');
        chest = await Chest.at('');
        usdt = await USDT.at('');
        pack = await Pack.at('');
    }
    // await chest.setMiner(lottery.address);
    // await item.setMiner(lottery.address);
    // await character.setMiner(lottery.address);
};