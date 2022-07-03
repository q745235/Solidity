const Ticket = artifacts.require("Ticket");
const USDT = artifacts.require("USDT");


module.exports = async function (deployer, network, accounts) {
    let usdtAddr;

    const ticket = await Ticket.deployed();
    
    if(network == 'test'){
        const usdt = await USDT.deployed();
        usdtAddr = usdt.address;
        await ticket.setTicketSellTime(1652673600,1673673600);
        await ticket.setUsdtContract(usdtAddr);
    }else if(network == 'bscTest'){
        let receive = '';
        usdtAddr = '';
        await ticket.setUsdtContract(usdtAddr);
        await ticket.setTwoWallet(receive);
        await ticket.setOneWallet(receive);
        await ticket.setThreeWallet(receive);
    }

};