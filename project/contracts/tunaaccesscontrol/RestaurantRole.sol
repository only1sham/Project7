pragma solidity ^0.5.0;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'RestaurantRole' to manage this role - add, remove, check
contract RestaurantRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
    event RestaurantAdded(address indexed account);
    event RestaurantRemoved(address indexed account);
  // Define a struct 'Restaurants' by inheriting from 'Roles' library, struct Role
  Roles.Role private Restaurant;

  // In the constructor make the address that deploys this contract the 1st Restaurant
  constructor() public {
  _addRestaurant(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyRestaurant() {
   require(isRestaurant(msg.sender),'Not a Restaurant address');
   _;
  }

  // Define a function 'isRestaurant' to check this role
  function isRestaurant(address account) public view returns (bool) {
   return Restaurant.has(account);
  }

  // Define a function 'addRestaurant' that adds this role
  function addRestaurant(address account) public {
   _addRestaurant(account);
  }

  // Define a function 'renounceRestaurant' to renounce this role
  function renounceRestaurant() public {
   _removeRestaurant(msg.sender);
  }

  // Define an internal function '_addRestaurant' to add this role, called by 'addRestaurant'
  function _addRestaurant(address account) internal {
  Restaurant.add(account);
  emit RestaurantAdded(account);
  }

  // Define an internal function '_removeRestaurant' to remove this role, called by 'removeRestaurant'
  function _removeRestaurant(address account) internal {
  Restaurant.remove(account);
  emit RestaurantRemoved(account);
  }
}