const DutchAuction = artifacts.require("DutchAuction");
const Character = artifacts.require("Character");
const USDT = artifacts.require("USDT");
contract("DutchAuction", async(accounts) => {
    let dutchAuction,character,usdt;
    let manager;
    let buyer;
    
    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        dutchAuction = await DutchAuction.deployed();
        character = await Character.deployed();
        usdt = await USDT.deployed();
    })
    it("set time", async() => {
        console.log(await web3.eth.getBalance(manager));
        await dutchAuction.setOneWallet('0xEC4dDD0C76AAf2278387726482127F87781473A0');
    });

    it("get price", async() => {
        let r = await dutchAuction.getPriceForUSDT();
        console.log("r",r/(1e18));//0.002
        setTimeout(async function(){
            r = await dutchAuction.getPriceForUSDT();
            console.log("r2", r/(1e18));//0.5
            },80001);
        r = await dutchAuction.getPriceForUSDT();
        console.log("r1", r/(1e18));//0.5
    });

    it("test Auction 1", async() => {
        await usdt.transfer(manager, web3.utils.toWei("100000"));
        await usdt.approve(
            dutchAuction.address,
            web3.utils.toWei("10000")
        );
        try {
            let r = await dutchAuction.winTheBidByUsdt();
            let r2 = await dutchAuction.getPriceForUSDT();
            console.log("r2", r2/(1e18));
            console.log(r);
            let h = await dutchAuction.getLowestPrice();
            console.log("highestPrice",h);
            console.log((new Date()).getTime());
            let t = await dutchAuction.getAuctionTime();
            console.log(t);
            let r3 = await dutchAuction.winTheBidByUsdt();
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