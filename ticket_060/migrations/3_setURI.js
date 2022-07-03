const Ticket = artifacts.require("Ticket");

module.exports = async function(deployer, network, accounts) {
  let ticket = await Ticket.deployed();
  await ticket.setBaseURI("https://q745235/tickets/");
  if(network == 'test' || network == 'bscTest'){
    await ticket.setTicketSellTime(1643173600, 9999999999);
  }
};
