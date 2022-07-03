const Ticket = artifacts.require("Ticket");
const USDT = artifacts.require("USDT");

contract("Ticket", async(accounts) => {
    let ticket;
    let manager;
    let buyer;
    let usdt;

    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        ticket = await Ticket.deployed();
        usdt = await USDT.deployed();
        // trade = await Trade.deployed();
        // chest = await Chest.at('0xb6C086860c58395d1C7c8a61522bfa5B54011351');
        // skill = await SkillCard.at('0x0906b819Bae56Fdd96258eEa81D83A978A550E7D');
    })
    it("Buy", async() => {
        const r = await usdt.balanceOf(manager);
        console.log({
            token: "USDT",
            address: manager,
            balance: String(r/10**18)
        });
        await usdt.transfer(manager, web3.utils.toWei("100000"));
        await usdt.approve(
            ticket.address,
            web3.utils.toWei("100000")
        );
        await ticket.setTicketSellTime(1643018280, 1643673600);
        await ticket.buyTicketByUsdt();
        await ticket.mint(manager);
        console.log(await ticket.uintToString(2022));
    });

    //應該要錯誤 : "You should buy ticket next time"
    it("sold out Permit", async() => {
        await ticket.setPermitSellAmount(1);
        let r = await ticket.buyTicketByUsdt();
        console.log("tokenURI", await ticket.tokenURI(1));
        console.log("permitSellAmount 1",await ticket.permitSellAmount());
        console.log("r1",r);
        await ticket.buyTicketByUsdt();
        console.log("permitSellAmount 2",await ticket.permitSellAmount());
        console.log("r2",r);
    });

    //應該要錯誤 : "Tickets sold out!"
    it("sold out Total", async() => {
        await ticket.setPermitSellAmount(1);
        await ticket.setTotalSellAmount(1);
        let r = await ticket.buyTicketByUsdt();
        console.log("r3",r);
        r = await ticket.mint(manager);
        console.log("r4",r);
    });

    it("test other", async() => {

    });

    // it("mint Chests", async() => {
    //     await chest.mint( buyer, 1, 10, {from: manager});
    //     await chest.mintBatch( buyer, [1,2,3], [10,10,10], {from: manager});
        // await skill.mint(seller, "101", "3",{
        //     x1: 0,
        //     x2: 0,
        //     x3: 0,
        //     y1: 0,
        //     y2: 0,
        //     y3: 0
        // }, {from: manager});
        // await skill.mint(seller, "301", "3",{
        //     x1: 0,
        //     x2: 0,
        //     x3: 0,
        //     y1: 0,
        //     y2: 0,
        //     y3: 0
        // }, {from: manager});
    // });

    // it("open Chest", async() => {
    //     await chest.openChest(1,1, { from: buyer });
    // });
    
});