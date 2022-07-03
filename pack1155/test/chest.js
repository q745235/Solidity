// const Trade = artifacts.require("Trade");
const Chest = artifacts.require("Chest");
const SkillCard = artifacts.require("SkillCard");

contract("Trade", async(accounts) => {

    let manager;
    let buyer;
    let skill;
    let chest;
    
    before(async() => {
        manager = accounts[0];
        buyer = accounts[1];

        // trade = await Trade.deployed();
        chest = await Chest.deployed();
        skill = await SkillCard.deployed();

        // trade = await Trade.deployed();
        // chest = await Chest.at('0xb6C086860c58395d1C7c8a61522bfa5B54011351');
        // skill = await SkillCard.at('0x0906b819Bae56Fdd96258eEa81D83A978A550E7D');
    })
    it("set Skill_miner", async() => {
        await skill.setMiner(chest, {from: manager});
    });

    it("set Chests", async() => {
        await chest.setOpen(1,true, {from: manager});
        await chest.setChestSkill(1,2,4,35, {from: manager});
        await chest.setChestSkill(1,101,4,35, {from: manager});
        await chest.setChestSkill(1,402,4,10, {from: manager});
        await chest.setChestSkill(1,602,4,10, {from: manager});
        await chest.setChestSkill(1,103,4,5, {from: manager});
        await chest.setChestSkill(1,402,5,2, {from: manager});
        await chest.setChestSkill(1,602,5,2, {from: manager});
        await chest.setChestSkill(1,103,5,1, {from: manager});
        await chest.setChestAmount(1,5, {from: manager});
        await chest.setSkillCardContract('0x0906b819Bae56Fdd96258eEa81D83A978A550E7D', {from: manager});
    });

    it("mint Chests", async() => {
        await chest.mint( buyer, 1, 10, {from: manager});
        await chest.mintBatch( buyer, [1,2,3], [10,10,10], {from: manager});
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
    });

    // it("open Chest", async() => {
    //     await chest.openChest(1,1, { from: buyer });
    // });
    
});