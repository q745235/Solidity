import { ethers } from "hardhat";
import {Ticket} from '../typechain';

(async() => {
    const ticketIns = await ethers.getContractFactory("Ticket");
    const ticketContract = <Ticket>ticketIns.attach(
        ""
    )
    for (let i = 3; i < 6; i++) {
        await ticketContract.setTokenURI(
            i, "ticket.json"
        )
    }
    
})()