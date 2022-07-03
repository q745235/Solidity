// import {ContractFactory} from 'ethers';
import {Permission} from '../../typechain';

export default async function (contractIns: MyContract, minter: string) {
    await contractIns.grantMinter(minter);
    console.log(`grant minter ${minter}`);
}

interface MyContract extends Permission{[key: string]: any}; 