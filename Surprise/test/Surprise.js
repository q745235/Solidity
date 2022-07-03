const Surprise = artifacts.require("Surprise");

contract("Surprise", async(accounts) => {
    let surprise;
    let manager;
    let buyer;



    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        surprise = await Surprise.deployed();

    })
    it("set time", async() => {
        console.log(await web3.eth.getBalance(manager));
        // await surprise.setBaseURI("https://q745235");
        // await surprise.setSurpriseIndexURI(1,"1.json");
        // await surprise.setSurpriseIndexURI(2,"2.json");
    });

    it("BNB form USDT", async() => {
        let r = await surprise.GetBNBAmountFromUSDTAmount(10);
        console.log("r",r/(1e18));//0.002
        r = await surprise.GetBNBAmountFromUSDTAmount(2500);
        console.log("r1", r/(1e18));//0.5

    });

    it("test receiveSurprise", async() => {
        await surprise.setLuckySurprise(101);
        let r = await surprise.receiveSurprise( {
            value: 25e18
        });
        console.log(r);
    });

    it("test change uri", async() => {
        let c = await surprise.tokenURI(101);
        console.log(c);
        await surprise.setLuckyTime(1646409600);
        c = await surprise.tokenURI(101);
        console.log(c);
    });

    it("test other", async() => {
        console.log("1",await surprise.surpriseCount());
        console.log("2",await surprise.tokenId2Surprise(100));
        console.log("3",await surprise.surpriseURI(1));
        console.log("4",await surprise.luckySurpriseURI());
    });
    
});