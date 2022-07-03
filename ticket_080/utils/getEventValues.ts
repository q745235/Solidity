import {ContractReceipt} from 'ethers';

export default function(
    receipt: ContractReceipt, eventName: string
): {[key: string]: any} {

    const events = receipt.events;
    for (let i = 0; i < events.length; i++) {
        if(events[i].event == eventName){
            const args = events[i].args;
            const returnValue = {};
            for (const key in args) {
                if (Object.prototype.hasOwnProperty.call(args, key)) {
                    returnValue[key] = args[key];
                }
            }
            return returnValue;
        }
    }
    return {}
}
