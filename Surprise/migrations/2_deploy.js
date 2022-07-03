const Surprise = artifacts.require("Surprise");

module.exports = function(deployer) {
  deployer.deploy(Surprise);
};
