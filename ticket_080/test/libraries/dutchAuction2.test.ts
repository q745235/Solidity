import { ethers, network } from "hardhat";
import deploy from '../../utils/deploy';
import increaseTime from '../../utils/evm/increaseTime';
import {TestDutchAuction2} from '../../typechain';
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers';

describe("DutchAuction", () => {
    let testDutchAuction: TestDutchAuction2;
    let owner: SignerWithAddress;

    before(async function(){
        testDutchAuction = <TestDutchAuction2>await deploy(
            "TestDutchAuction2"
        );
        [owner] = await ethers.getSigners();

        await network.provider.send("evm_mine");
    });

    it('new sale', async function(){
        const now = Math.floor(Date.now() / 1000);
        console.log({
            now: now
        });
        await testDutchAuction.newSale(
            ethers.utils.parseEther("10"), //interval
            now, //startTime
            ethers.utils.parseEther("100"), //startPrice
            ethers.utils.parseEther("0.3"), //decrease
            
        )
    });

    it('get price', async function(){
        console.log(await testDutchAuction.getPrice());
        // this.timeout(30000);
        for (let i = 0; i <= 120; i++) {
            const r = await getPrice();
            console.log({
                Price: r,
                Count: i
            });
            // await network.provider.send("evm_increaseTime", [10]);
            // await network.provider.send("evm_mine");//必須出塊才會影響時間
            await increaseTime(network, 3);
            // await sleep(1000);
        }
    });

    async function getPrice(){
        return ethers.utils.formatEther(await testDutchAuction.getPrice());
    }


    //await network.provider.send("evm_setNextBlockTimestamp", [1625097600])
    //await network.provider.send("evm_mine") // this one will have 2021-07-01 12:00 AM as its timestamp, no matter what the previous block has
})