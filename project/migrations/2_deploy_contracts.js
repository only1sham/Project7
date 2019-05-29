// migrating the appropriate contracts
// var FishermanRole = artifacts.require("./FishermanRole.sol");
// var RegulatorRole = artifacts.require("./RegulatorRole.sol");
// var RestaurantRole = artifacts.require("./RestaurantRole.sol");
// var SupplyChain = artifacts.require("./SupplyChain.sol");
var ValueChain = artifacts.require("./ValueChain.sol");

module.exports = function(deployer) {
  // deployer.deploy(FishermanRole);
  // deployer.deploy(RegulatorRole);
  // deployer.deploy(RestaurantRole);
  // deployer.deploy(SupplyChain);
  deployer.deploy(ValueChain);
};
