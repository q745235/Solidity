import { expect } from "chai";
import { ethers, network } from "hardhat";
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers';
import {Ticket, ERC20Base} from '../typechain';
import deployTicket from '../process/migrateTest';
import setFee from '../process/setFee';
import setTimestamp from '../utils/evm/setTimestamp';
import isRevert from '../utils/isRevert';

describe("Ticket", () => {
    let ticket: Ticket;
    let fakeUsdt: ERC20Base;
    let owner: SignerWithAddress;
    let buyer: SignerWithAddress;
    let CMTAddress = "";
    let OneAddress = "";
    let TwoAddress = "";
    let ThreeAddress = "";
    const normalBuy = 0;
    const whiteListBuy = 1;
    
    before(async() => {
        const myContract = await deployTicket();
        ticket = <Ticket>myContract.ticket;
        fakeUsdt = <ERC20Base>myContract.FUSDT;
        [owner, buyer] = await ethers.getSigners();

        await ticket.setPurchaseTime(
            1669791800, //Fri Apr 23 2022 11:30:00 GMT+0800,
            1670223800 //Sun Apr 24 2022 11:30:00 GMT+0800
        );

        await setFee(ticket);
    });

    it("transfer usdt to buyer", async() => {
        await fakeUsdt.transfer(
            buyer.address,
            ethers.utils.parseEther("100000")
        )
    })

    it('check balances', checkBalances);

    it("buyer approve usdt", async() => {
        await fakeUsdt.connect(buyer).approve(
            ticket.address,
            ethers.utils.parseEther("100000")
        )
    })

    it("buy nft before sell time", async() => {
        await isRevert(async() => {
            await setTimestamp(network, 1648137600);
            //Fri Mar 25 2022 00:00:00 GMT+0800

            await ticket.connect(buyer).buy();
        })
    })

    it("buy nft in sell time", async() => {
        await setTimestamp(network, 1660000000);
        //Sun Apr 12 2022 23:33:20 GMT+0800

        await ticket.connect(buyer).buy();
    })

    it("buy nft after sell time", async() => {
        await isRevert(async() => {
            await setTimestamp(network, 1660223800);
            //Wed Nov 15 2023 06:13:20 GMT+0800

            await ticket.connect(buyer).buy();
        })
    })

    it('check balances', checkBalances);

    async function checkBalances(){
        console.log({
            buyer: await getUsdtBalance(buyer.address),
            owner: await getUsdtBalance(owner.address),
            CMT: await getUsdtBalance(CMTAddress),
            One: await getUsdtBalance(OneAddress),
            Two: await getUsdtBalance(TwoAddress),
            Three: await getUsdtBalance(ThreeAddress),
        });
    }

    async function getUsdtBalance(address: string){
        const r = await fakeUsdt.balanceOf(address);
        return ethers.utils.formatEther(r);
    }
    
})