import { Address } from "cluster";
import { ethers } from "hardhat";
import { Ticket } from "../typechain";
import deploy from '../utils/deploy';

export default async function(ticket: Ticket, whiteliset: string){
    // 2022/4/22 08:00
    await ticket.setApproveWhiteList(whiteliset, true);
}