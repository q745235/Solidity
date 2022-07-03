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
    let buyer2: SignerWithAddress;
    let IBiZaAddress = "";
    let OneAddress = "";
    let TwoAddress = "";
    let ThreeAddress = "";
    const normalBuy = 0;
    const whiteListBuy = 1;
    
    before(async() => {
        const myContract = await deployTicket();
        ticket = <Ticket>myContract.ticket;
        fakeUsdt = <ERC20Base>myContract.FUSDT;
        [owner, buyer, buyer2] = await ethers.getSigners();

        await ticket.setPurchaseTime(
            1669792400, //Wed Apr 23 2022 03:40:00 GMT+0800,
            1670224000 //Thu Aug 24 2022 21:20:00 GMT+0800
        );

        await setFee(ticket);
    });

    it("transfer usdt to buyer", async() => {
        await fakeUsdt.transfer(
            buyer.address,
            ethers.utils.parseEther("100000")
        )
    })


    it("buyer approve usdt", async() => {
        await fakeUsdt.connect(buyer).approve(
            ticket.address,
            ethers.utils.parseEther("100000")
        )
    })

    it("set time", async() => {
        await setTimestamp(network, 1650092400);
        //Thu Aug 11 2022 21:20:00 GMT+0800
    })

    it("buy normal nft", async() => {
        for (let i = 0; i < 8; i++) {
            await ticket.connect(buyer).batchBuy(100);
        }
    })

    it("buy normal nft", async() => {
        await isRevert(async() => {
            await ticket.connect(buyer).batchBuy(100);
        })
    })
    
})