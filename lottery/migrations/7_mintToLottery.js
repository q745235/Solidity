const Lottery = artifacts.require("Lottery");
const ItemCard = artifacts.require("ItemCard");
const Character = artifacts.require("Character");
const Pack = artifacts.require("ItemCardPack");

module.exports = async function (deployer, network, accounts) {
    const lottery = await Lottery.deployed();
    let item;
    let character;
    let pack;
    
    if(network == 'test'){
        item = await ItemCard.deployed();
        character = await Character.deployed();
        pack = await Pack.deployed();
        //mint character to lottery
        await character.mint(lottery.address, 201, [25,25,25,25]);
        await character.mint(lottery.address, 202, [25,25,25,25]);
        await character.mint(lottery.address, 203, [25,25,25,25]);
        await pack.mint(lottery.address,1);
        await pack.mint(lottery.address,1);
        await pack.mint(lottery.address,1);
        await pack.mint(lottery.address,11);
        await pack.mint(lottery.address,11);
        await pack.mint(lottery.address,11);
        await item.mint(
            lottery.address, 
            "200",
            "6",
            {x1: 1, x2: 1, y3: 1, y2: 1, z1: 1, z2: 1}
        )

        await web3.eth.sendTransaction({
            from: accounts[0],
            to: lottery.address,
            value: web3.utils.toWei("0.02")
        });
    }else if(network == 'bscTest'){
        item = await ItemCard.at('');
        character = await Character.at('');
    }

    
};