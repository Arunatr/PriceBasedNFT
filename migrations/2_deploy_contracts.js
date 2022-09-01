var PriceBasedNft = artifacts.require("priceBasedNft.sol");

module.exports = function(deployer) {
  deployer.deploy(PriceBasedNft,'Arun','AAA');
};

