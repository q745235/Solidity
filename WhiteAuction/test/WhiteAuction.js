const WhiteAuction = artifacts.require("WhiteAuction");
const Character = artifacts.require("Character");
const USDT = artifacts.require("USDT");
contract("WhiteAuction", async(accounts) => {
    let whiteAuction,character,usdt;
    let manager;
    let buyer;
    
    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        whiteAuction = await WhiteAuction.deployed();
        character = await Character.deployed();
        usdt = await USDT.deployed();
    })
    it("set time", async() => {
        console.log(await web3.eth.getBalance(manager));
        await whiteAuction.setOneWallet('0xEC4dDD0C76AAf2278387726482127F87781473A0');
    });

    it("get price", async() => {
        let r = await whiteAuction.getPriceForUSDT();
        console.log("r",r/(1e18));
    });

    it("test Auction 1", async() => {
        await usdt.transfer(manager, web3.utils.toWei("100000"));
        await usdt.approve(
            whiteAuction.address,
            web3.utils.toWei("10000")
        );
        try {
            await whiteAuction.setCustomer([manager],true);
            let r = await whiteAuction.winTheBidByUsdt();
            let r2 = await whiteAuction.getPriceForUSDT();
            console.log("r2", r2/(1e18));
            console.log(r);
            let r3 = await whiteAuction.winTheBidByUsdt(); //會無法完成交易
            console.log(r3);
        } catch (error) {
            console.log(error);
        }
        
    });
    async function showUsdtBlance(address){
        const r = await usdt.balanceOf(address);
        console.log({
            token: "USDT",
            address: address,
            balance: String(r/10**18)
        });
    }
});