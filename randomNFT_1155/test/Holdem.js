const RandomNFT = artifacts.require("RandomNFT");
const USDT = artifacts.require("USDT");
contract("RandomNFT", async(accounts) => {
    let randomNFT,usdt;
    let manager;
    let buyer;
    
    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        randomNFT = await RandomNFT.deployed();
        usdt = await USDT.deployed();
    })
    it("set time", async() => {
        console.log(await web3.eth.getBalance(manager));
        await randomNFT.setOneWallet('0xEC4dDD0C76AAf2278387726482127F87781473A0');
    });

    it("get price", async() => {
        let r = await randomNFT.getPriceForUSDT();
        console.log("r",r/(1e18));//0.002
    });

    it("test buy 1", async() => {
        await usdt.transfer(manager, web3.utils.toWei("100000"));
        await usdt.approve(
            randomNFT.address,
            web3.utils.toWei("10000")
        );
        let c =  await  randomNFT.buyChipsByUsdt();
        console.log("c",c);
    });

    it("test buy 2", async() => {
        await usdt.transfer(manager, web3.utils.toWei("10000"));
        await usdt.approve(
            randomNFT.address,
            web3.utils.toWei("10000")
        );
        let w =  await  randomNFT.buyChipsBatchByUsdt(5);
        console.log("w",w);
    });

    it("test set 12", async() => {
        await usdt.transfer(manager, web3.utils.toWei("10000"));
        await usdt.approve(
            randomNFT.address,
            web3.utils.toWei("10000")
        );
        let w =  await  randomNFT.setNewPermitSell(10,5,5);
        console.log("w",w);

        let q =  await  randomNFT.setNewPermitSell(10,5,2);//會出錯
        console.log("q",q);
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