const Ticket = artifacts.require("Ticket");

module.exports = async function(deployer, network, accounts) {
  let ticket = await Ticket.deployed();

  if(network == 'bsc'){
    await ticket.setTwoWallet();
    await ticket.setOneWallet();
    await ticket.setThreeWallet();
    await ticket.setArtistWallet();
  }
};
