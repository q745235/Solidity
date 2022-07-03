import { expect } from "chai";

export default async function(func: () => Promise<void>){
    let isError = false;
    try {
        await func()
    } catch (error) {
        let r = <Error>error;
        console.log(r.message);
        isError = true;
    }
    if(!isError){
        throw new Error("isRevert: the transaction should not be success");
    }
}