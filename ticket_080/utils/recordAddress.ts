import fs from 'fs';

export function getAddress(net: string, contractName: string){
    const allData = readFileData(net);
    return allData[contractName].address;
}

export function writeNewAddress(
    net: string,
    contractName: string,
    address: string
){
    const allData = readFileData(net);
    const newData = {
        address: address,
        deployTime: (new Date()).toLocaleString()
    }
    allData[contractName] = newData;
    fs.writeFileSync(netToFileName(net), JSON.stringify(allData));
}


export function readFileData(net: string): Data{
    const dir = netToFileName(net);
    const data = fs.readFileSync(dir);
    return JSON.parse(data.toString());
}

function netToFileName(net: string){
    return `./address/${net}.json`;
}

type Data = {
    [key: string]: {
        address: string,
        deployTime: string
    }
}

