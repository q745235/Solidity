import { ethers } from "hardhat";
import deploy from '../../utils/deploy';
import {TestStatistics} from '../../typechain';
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers';

describe("Statistics", () => {
    let testStatistics: TestStatistics;
    let owner: SignerWithAddress;
    
    before(async() => {
        testStatistics = <TestStatistics>await deploy(
            "TestStatistics"
        );
        [owner] = await ethers.getSigners();
    });
    
    it('addAmount', async() => {
        await testStatistics.addAmount("Gold", 8);
        await testStatistics.addAmount("Silver", 3);
        await testStatistics.addAmount("Copper", 12);
    });

    it('addAmount2', async() => {
        await testStatistics.addAmount("Wood", 1);
        await testStatistics.addAmount("Gold", 1);
        await testStatistics.addAmount("Copper", 2);
    });

    it('getLength', async() => {
        const r = await testStatistics.getLength();
        console.log({
            length: r
        });
    });

    it('getItems', async() => {
        const r = await testStatistics.getItems();
        console.log({
            Items: r
        });
    });

    it('getAmount', async() => {
        let goldAmount =  testStatistics.getAmount("Gold");
        let silverAmount =  testStatistics.getAmount("Silver");
        let copperAmount =  testStatistics.getAmount("Copper");
        let stoneAmount =  testStatistics.getAmount("Stone");

        const amounts = await Promise.all([
            goldAmount, silverAmount, copperAmount, stoneAmount
        ])

        console.log({
            Gold: amounts[0],
            Silver: amounts[1],
            Copper: amounts[2],
            Stone: amounts[3],
        });
    });
})