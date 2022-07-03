import { ethers } from "hardhat";
import { Ticket } from "../typechain";
import deploy from '../utils/deploy';
import setFee from "./setFee";
import setTime from "./setTime";
import setWhitelist from "./setWhitelist";

export default async function migrateTicket(qUsdtAddress?: string){
    const ticket = <Ticket>await deploy(
        "Ticket", {
            parms: [
                "Ticket",
                "q745235",
                "https://q745235/ticket/"
            ]
        }
    );
    await setFee(ticket);
    await setTime(ticket);
    await setWhitelist(ticket,"");
    if(qUsdtAddress){
        await ticket.setUsdtContract(qUsdtAddress);
        return {
            ticket: ticket
        };
    }else{
        const qUsdt =  await deploy(
            "ERC20Base", {
                parms: [
                    ethers.utils.parseEther("1000000"),
                    "Q Usdt",
                    "QUSDT"
                ]
            }
        )
        await ticket.setUsdtContract(qUsdt.address);
        return {
            ticket: ticket,
            QUSDT: qUsdt
        };
    }
}


