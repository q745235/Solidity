import { ethers } from "hardhat";
import {Ticket} from '../typechain';

(async() => {
    const ticketIns = await ethers.getContractFactory("Ticket");
    const ticketContract = <Ticket>ticketIns.attach(
        ""
    )
    // 正式鏈測試用
    // const ticketContract = <Ticket>ticketIns.attach(
    //     ""
    // )
    
    // for (let i = 0; i < 1; i++) {
    //     await ticketContract.mint(
    //         "",
    //         "ticket.json"
    //     )
    // }
    // await ticketContract.setApproveWhiteList('',true);
    // await ticketContract.setPurchaseTime(1650585600, 6650327900);
    // await ticketContract.setTicketPrice(ethers.utils.parseEther("0.0001"));
    // await ticketContract.setUsdtContract('');
    // await ticketContract.mintBatch([
    // ],"ticket.json");
    console.log("purchaseStartTime",await ticketContract.purchaseStartTime());
    console.log("purchaseEndTime",await ticketContract.purchaseEndTime());
    console.log("totalSupply",await ticketContract.totalSupply());
    console.log("balanceOf",await ticketContract.balanceOf(
        ''
        ));
    console.log("getAllWallet",await ticketContract.getAllWallet());
    console.log("usdtContract",await ticketContract.usdtContract());
    console.log("getFeeByWallet, One",await ticketContract.getFeeByWallet(
        ""
    ));
    console.log("getFeeByWallet, Two",await ticketContract.getFeeByWallet(
        ""
    ));
    console.log("getFeeByWallet, Three",await ticketContract.getFeeByWallet(
        ""
    ));
    console.log("ticketAmount",await ticketContract.getStatisticsAmount("ticket"));
    console.log("ticketLimited",await ticketContract.getStatisticsLimited("ticket"));
    console.log("ticketPrice",ethers.utils.formatEther( await ticketContract.ticketPrice()));
    // await ticketContract.setApproveWhiteList('',true);
    console.log("approveWhiteList",await ticketContract.approveWhiteList(''));
    // await ticketContract.setAmounts("ticket",887);
    // let OneAddress = "";
    // let TwoAddress = "";
    // let ThreeAddress = "";

    // await ticketContract.setFees([
    //     150, 150, 700
    // ],[
    //      OneAddress, TwoAddress, ThreeAddress
    // ])
})()