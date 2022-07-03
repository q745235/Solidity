import $ from "jquery";
import Web3 from "web3/dist/web3.min";
import axios from "axios";
window.ethereum.request({method:'eth_requestAccounts'});
const web3 = new Web3(window.ethereum);
const web3Not = new Web3('https://bsc-dataseed.binance.org');

$("button").on("click", async() => {
    console.log("object");
    const address = await getAddress();
    console.log(address);
    const sign = await web3.eth.personal.sign(
        web3.utils.utf8ToHex("Test sign this address"),
        address,
    )
    console.log(sign);
})

async function getAddress(){
    console.log((await web3.eth.getAccounts()));
    return (await web3.eth.getAccounts())[0];
};