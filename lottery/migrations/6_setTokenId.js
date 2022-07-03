const Lottery = artifacts.require("Lottery");
const Character = artifacts.require("Character");
const Pack = artifacts.require("ItemCardPack");
const ItemCard = artifacts.require("ItemCard");

module.exports = async function (deployer, network, accounts) {
    const lottery = await Lottery.deployed();
    let character;
    let pack;
    let item;
    await lottery.setTokenId(0, 201000);
    await lottery.setTokenId(1, 202000);
    await lottery.setTokenId(2, 203000);
    await lottery.setTokenId(3, 1006000);
    await lottery.setTokenId(4, 1000);
    await lottery.setTokenId(5, 1001);
    await lottery.setTokenId(6, 1002);
    await lottery.setTokenId(14, 11000);
    await lottery.setTokenId(15, 11001);
    await lottery.setTokenId(16, 11002);
    if(network == "bscTest"){
        item = await ItemCard.at('');
        character = await Character.at('');
        pack = await Pack.at('');
        await lottery.setTokenId(4, 1017);
        await lottery.setTokenId(5, 1015);
        await lottery.setTokenId(6, 1016);
        await lottery.setTokenId(14, 11015);
        await lottery.setTokenId(15, 11012);
        await lottery.setTokenId(16, 11018);
    }
};