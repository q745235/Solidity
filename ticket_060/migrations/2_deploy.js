const Ticket = artifacts.require("Ticket");
const USDT = artifacts.require("USDT");
module.exports = function(deployer, network, accounts) {
  if(network == 'test'){
    deployer.deploy(USDT);
  }
  deployer.deploy(Ticket);
};
