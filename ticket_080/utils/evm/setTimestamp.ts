import { Network } from "hardhat/types";

/**
 * @param network evm network
 * @param time timestamp (unix time))
 */
export default async function(network: Network, timestamp: number){
    await network.provider.send("evm_setNextBlockTimestamp", [timestamp])
    await network.provider.send("evm_mine");
}