import { ethers } from "hardhat";
import {Ticket} from '../typechain';

(async() => {
    const ticketIns = await ethers.getContractFactory("Ticket");
    const ticketContract = <Ticket>ticketIns.attach(
        ""
    )
    // for (let i = 0; i < 1; i++) {
    //     await ticketContract.mint(
    //         "",
    //         "ticket.json"
    //     )
    // }
    await ticketContract.setPurchaseTime(1650585600, 6650327900);
    // await ticketContract.setApproveWhiteList('',true);
    // await ticketContract.setStartApproveList(true);
    // await ticketContract.setAmounts("ticket",40);
    // await ticketContract.setLimiteds("ticket",888);
    // await ticketContract.setAmounts("ticket",878);
    // console.log("balanceOf",await ticketContract.balanceOf(
    //     ''
    //     ));
    console.log("getAllWallet",await ticketContract.getAllWallet());
    console.log("getFeeByWallet",await ticketContract.getFeeByWallet(
        ""
    ));
    console.log("ticket",await ticketContract.getStatisticsAmount("ticket"));
    // await ticketContract.setApproveWhiteList('',true);
    console.log(await ticketContract.approveWhiteList(''));
    // let OneAddress = "";
    // let TwoAddress = "";
    // let ThreeAddress = "";

    // await ticketContract.setFees([
    //     150, 150, 700
    // ],[
    //      OneAddress, TwoAddress, ThreeAddress
    // ])
})()