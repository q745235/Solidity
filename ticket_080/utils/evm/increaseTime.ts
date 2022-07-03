import { Network } from "hardhat/types";

/**
 * @param network evm network
 * @param time increase time (sec)
 */
export default async function(network: Network, time: number){
    await network.provider.send("evm_increaseTime", [time]);
    await network.provider.send("evm_mine");//必須出塊才會影響時間
}