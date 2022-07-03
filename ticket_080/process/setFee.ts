import { ethers } from "hardhat";
import { Ticket } from "../typechain";
import deploy from '../utils/deploy';

export default async function(ticket: Ticket){
    let OneAddress = "";
    let TwoAddress = "";
    let ThreeAddress = "";

    await ticket.setFees([
        150, 150, 700
    ],[
         OneAddress, TwoAddress, ThreeAddress
    ])
}