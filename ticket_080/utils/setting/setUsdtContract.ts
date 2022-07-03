import {ContractFactory} from 'ethers';
import {PayUsdt} from '../../typechain';

export default async function (contractIns: MyContract, usdtAddress: string) {
    await contractIns.setUsdtAddress(usdtAddress);
    console.log(`set usdtAddress ${usdtAddress}`);
}

interface MyContract extends ContractFactory{[key: string]: any}; 