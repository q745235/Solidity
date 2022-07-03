import hardhat, { ethers, network } from "hardhat";

export default async function(prams: Prams){
    console.log(`Using network ${network.name}...`);
    await hardhat.run("verify:verify", prams);
}

type Prams = {
    address: string
    contract?: string,
    constructorArguments ?: any[],
    [key: string]: any
}