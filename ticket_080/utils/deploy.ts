import { ethers, network } from "hardhat";
import {Contract} from 'ethers';
import {writeNewAddress} from '../utils/recordAddress';

export default async function (
    contractName: string, options: Options = {}
): Promise<Contract> {
    console.log(`Using network ${network.name} ...`);
    let contractIns: Contract;
    const libraryAddress = {};
    if(options.libraries && options.libraries.length != 0){
        for (let i = 0; i < options.libraries.length; i++) {
            const libraryString = options.libraries[i];
            const Library = await ethers.getContractFactory(libraryString);
            const library = await Library.deploy();
            libraryAddress[libraryString] = library.address;
        }
        const contractClass = await ethers.getContractFactory(contractName, {
            libraries: libraryAddress,
        });
        if(options.parms && options.parms.length !== 0){
            contractIns = await contractClass.deploy(...options.parms);
        }else{
            contractIns = await contractClass.deploy();
        }
    }else{
        const contractClass = await ethers.getContractFactory(contractName);
        if(options.parms && options.parms.length !== 0){
            contractIns = await contractClass.deploy(...options.parms);
        }else{
            contractIns = await contractClass.deploy();
        }  
    }
    console.log(`${contractName} deployed to:`, contractIns.address);
    writeNewAddress(network.name, contractName, contractIns.address);
    return contractIns;
}

type Options = {
    parms?: any[],
    libraries?: string[]
}