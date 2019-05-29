pragma solidity ^0.5.0;

import "../tunabase/SupplyChain.sol";
import "./Ownable.sol";

/// Provides basic authorization control
contract ValueChain is SupplyChain, Ownable {

    constructor() public payable {
    }

  // Define a function 'kill' if required
  function kill() public onlyOwner() {
      selfdestruct(msg.sender);
    }

  // Define a function to transfer ownership
  function transferOwner(address newOwner) public onlyOwner() {
      transferOwnership(newOwner);
    }
}