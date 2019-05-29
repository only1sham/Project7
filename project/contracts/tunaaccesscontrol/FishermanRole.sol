pragma solidity ^0.5.0;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'FishermanRole' to manage this role - add, remove, check
contract FishermanRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event FishermanAdded(address indexed account);
  event FishermanRemoved(address indexed account);

  // Define a struct 'Fishermen' by inheriting from 'Roles' library, struct Role
  Roles.Role private Fishermen;

  // In the constructor make the address that deploys this contract the 1st Fisherman
  constructor() public {
    _addFisherman(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyFisherman() {
    require(isFisherman(msg.sender), 'Not a Fisherman');
    _;
  }

  // Define a function 'isFisherman' to check this role
  function isFisherman(address account) public view returns (bool) {
    return Fishermen.has(account);
  }

  // Define a function 'addFisherman' that adds this role
  function addFisherman(address account) public {
    _addFisherman(account);
  }

  // Define a function 'renounceFisherman' to renounce this role
  function renounceFisherman() public {
    _removeFisherman(msg.sender);
  }

  // Define an internal function '_addFisherman' to add this role, called by 'addFisherman'
  function _addFisherman(address account) internal {
    Fishermen.add(account);
    emit FishermanAdded(account);
  }

  // Define an internal function '_removeFisherman' to remove this role, called by 'removeFisherman'
  function _removeFisherman(address account) internal {
    Fishermen.remove(account);
    emit FishermanRemoved(account);
  }
}