import { ethers, network } from "hardhat";
import deploy from '../../utils/deploy';
import increaseTime from '../../utils/evm/increaseTime';
import {TestDutchAuction1} from '../../typechain';
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers'

describe("DutchAuction", () => {
    let testDutchAuction: TestDutchAuction1;
    let owner: SignerWithAddress;

    before(async function(){
        testDutchAuction = <TestDutchAuction1>await deploy(
            "TestDutchAuction1"
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
            now, //startTime
            now+500, //endTime
            ethers.utils.parseEther("100"), //startPrice
            ethers.utils.parseEther("50"), //endPrice
            ethers.utils.parseEther("10") //interval
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