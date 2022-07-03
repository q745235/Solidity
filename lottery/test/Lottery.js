const Lottery = artifacts.require("Lottery");
const Chest = artifacts.require("Chest");
const ItemCard = artifacts.require("ItemCard");
const Character = artifacts.require("Character");
const USDT = artifacts.require("USDT");

contract("Lottery", async(accounts) => {

    //people
    let manager, people1;
    //contract
    let character, item, chest, lottery, usdt;
    let wallet = ''

    before(async() => {
        manager = accounts[0];
        people1 = accounts[1];

        chest = await Chest.deployed();
        item = await ItemCard.deployed();
        character = await Character.deployed();
        lottery = await Lottery.deployed();
        usdt = await USDT.deployed();
    })

    it('Transfer USDT', async() => {
        await usdt.transfer(people1, web3.utils.toWei("10000"));
        await showUsdtBlance(manager);
        await showUsdtBlance(people1);
    });

    it("Get info", async() => {
        const lotteryPriceForUSDT = await lottery.getLotteryPriceForUSDT();
        const totalSellAmount = await lottery.totalSellAmount();

        console.log({
            lotteryPriceForUSDT: String(lotteryPriceForUSDT/10**18),
            totalSellAmount: String(totalSellAmount/10**18)
        });
    });

    // it("mint character to lottery", async() => {
    //     await character.mint(lottery.address, 201, [25,25,25,25]);
    //     await character.mint(lottery.address, 202, [25,25,25,25]);
    //     await character.mint(lottery.address, 203, [25,25,25,25]);
    // });

    // it("mint item to lottery", async() => {
    //     await item.mint(
    //         lottery.address, 
    //         "200",
    //         "6",
    //         {x1: 0, x2: 0, y1: 0, y2: 0, z1: 0, z2: 0}
    //     )
    // });

    // it("transfer bnb to lottery", async() => {
    //     await web3.eth.sendTransaction({
    //         from: manager,
    //         to: lottery.address,
    //         value: web3.utils.toWei("0.02")
    //     });
    // });

    it("lottery", async() => {
        await usdt.approve(
            lottery.address,
            web3.utils.toWei("10000")
        );
        let r =  await lottery.lotteryByUsdt();
        console.log("lotteryByUsd1",r);
        r =  await lottery.lotteryByUsdt();
        console.log("lotteryByUsd2",r);
        r =  await lottery.lotteryByUsdt();
        console.log("lotteryByUsd3",r);
    });

    it('Check USDT Value', async() => {
        await showUsdtBlance(people1);
        await showUsdtBlance(wallet);
    });

    // it("mint Chests", async() => {
    //     await chest.mint( buyer, 1, 10, {from: manager});
    //     await chest.mintBatch( buyer, [1,2,3], [10,10,10], {from: manager});
        // await item.mint(seller, "101", "3",{
        //     x1: 0,
        //     x2: 0,
        //     y1: 0,
        //     y2: 0,
        //     z1: 0,
        //     z2: 0
        // }, {from: manager});
        // await item.mint(seller, "301", "3",{
        //     x1: 0,
        //     x2: 0,
        //     y1: 0,
        //     y2: 0,
        //     z1: 0,
        //     z2: 0
        // }, {from: manager});
    // });

    // it("open Chest", async() => {
    //     await chest.openChest(1,1, { from: buyer });
    // });
    
    async function showUsdtBlance(address){
        const r = await usdt.balanceOf(address);
        console.log({
            token: "USDT",
            address: address,
            balance: String(r/10**18)
        });
    }
});