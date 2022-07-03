import { ethers } from "hardhat";
import { Ticket } from "../typechain";
import deploy from '../utils/deploy';

export default async function(ticket: Ticket){
    // 2022/4/22 08:00
    await ticket.setPurchaseTime(1650585600, 6650327900);
}