const Trade = artifacts.require("Trade");
const Hero = artifacts.require("Hero");
const SkillCard = artifacts.require("SkillCard");

contract("Trade", async(accounts) => {

    let manager;
    let seller;
    let buyer;

    let trade;
    let hero;
    let skill;

    let NFTs;
    

    before(async() => {
        manager = accounts[0];
        seller = accounts[1];
        buyer = accounts[2];

        trade = await Trade.deployed();
        hero = await Hero.deployed();
        skill = await SkillCard.deployed();

        // trade = await Trade.deployed();
        // hero = await Hero.at('0xaDC2AB20f7D0906A55C3CE58808179A1Ac29DC69');
        // skill = await SkillCard.at('0x0906b819Bae56Fdd96258eEa81D83A978A550E7D');
    })

    it("mint NFTs", async() => {
        await hero.mint(seller, "123", {
            HPbase: 25,
            ATKbase: 25,
            DEFbase: 25,
            LUKbase: 25,
        }, {from: manager});
        await hero.mint(seller, "224", {
            HPbase: 27,
            ATKbase: 22,
            DEFbase: 27,
            LUKbase: 24,
        }, {from: manager});
        await skill.mint(seller, "101", "3",{
            x1: 0,
            x2: 0,
            x3: 0,
            y1: 0,
            y2: 0,
            y3: 0
        }, {from: manager});
        await skill.mint(seller, "301", "3",{
            x1: 0,
            x2: 0,
            x3: 0,
            y1: 0,
            y2: 0,
            y3: 0
        }, {from: manager});
    });

    it("query Nfts", async() => {
        NFTs = await showNFTs()
        console.log(NFTs);
    });

    it("approve NFTs", async() => {
        await hero.approve(trade.address, NFTs.seller.heroArray[0], {
            from: seller
        });
        await skill.approve(trade.address, NFTs.seller.skillArray[0], {
            from: seller
        })
    });

    it("sell", async() => {
        await trade.sellNft(
            hero.address, NFTs.seller.heroArray[0], 
            web3.utils.toWei("0.5", "ether"), "0", {
                from: seller
            }
        )

        await trade.sellNft(
            skill.address,
            NFTs.seller.skillArray[0],
            "0",
            web3.utils.toWei("1000", "ether"),
            {
                from: seller
            }
        )
    });

    it('show all order', async() => {
        console.log(await getAllOrder());
    })

    it("query Nfts", async() => {
        NFTs = await showNFTs()
        console.log(NFTs);
    });

    it('cancel', async() => {
        await trade.cancelSell(1, {
            from: seller
        })
    })

    // it('buy', async() => {
    //     await trade.buyNftByBnb(1, {
    //         from: buyer,
    //         value: web3.utils.toWei("0.5", "ether")
    //     })
    // })

    it("query Nfts", async() => {
        NFTs = await showNFTs()
        console.log(NFTs);
    });

    it('show all order', async() => {
        console.log(await getAllOrder());
    })

    async function getAllOrder(){
        const query = [];

        const r = await trade.getAllTradableOrder();
        const allOrder = r.map(r => {return r.toString()})

        for (let i = 0; i < allOrder.length; i++) {
            const orderId = allOrder[i];
            query.push(trade.getOrderInfo(orderId));
        }

        const orderList = await Promise.all(query);
        return orderList.map(r => {
            return {
                state: r.state,
                tokenContract: r.tokenContract,
                tokenId: r.tokenId,
                BNBPrice: r.BNBPrice,
                USDTPrice: r.USDTPrice,
                seller: r.seller,
                buyer: r.buyer,
                createTime: r.createTime
            }
        });
    }

    async function showNFTs(){

        //buyer
        const buyerHeroArray = await getNftList(hero, buyer);
        const buyerSkillArray = await getNftList(skill, buyer);

        //seller
        const sellerHeroArray = await getNftList(hero, seller);
        const sellerSkillArray = await getNftList(skill, seller);

        return {
            buyer: {
                heroArray: buyerHeroArray,
                skillArray: buyerSkillArray
            },
            seller:{
                heroArray: sellerHeroArray,
                skillArray: sellerSkillArray
            }
        }
    }

    //The contract needs to be a NFT
    async function getNftList(contract, address){
        const query = [];
        const balance = await contract.balanceOf(address);

        for (let i = 0; i < Number(balance.toString()); i++) {
            query.push(contract.tokenOfOwnerByIndex(address, i));
        }

        const results = await Promise.all(query);
        return results.map(r => {return r.toString()})
    }
    
});