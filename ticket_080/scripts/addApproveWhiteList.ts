import { ethers } from "hardhat";
import {Ticket} from '../typechain';

(async() => {
    const ticketIns = await ethers.getContractFactory("Ticket");
    const ticketContract = <Ticket>ticketIns.attach(
        ""
    )
    ticketContract.attach(
        ""
    ).setApproveWhiteList(
        "",
        true
    );
})()