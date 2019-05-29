pragma solidity ^0.5.0;

import "../tunaaccesscontrol/FishermanRole.sol";
import "../tunaaccesscontrol/RegulatorRole.sol";
import "../tunaaccesscontrol/RestaurantRole.sol";

// Define a contract 'Supplychain'


contract SupplyChain is FishermanRole, RegulatorRole, RestaurantRole {

// Define 'owner'
  address supplyChainOwner;

  // Define a variable called 'upc' for Universal Product Code (UPC)
  uint  upc;

  // Define a variable called 'sku' for Stock Keeping Unit (SKU)
  uint  sku;

// Define enum 'State' with the following values:
  enum State
  {
    Caught,  // 0
    Recorded,  // 1
    Audited,     // 2
    Bought    // 3
  }

  State constant defaultState = State.Caught;

  // Define a struct 'Item' with the following fields:
  struct TunaFish {
    uint    sku;  // Stock Keeping Unit (SKU)
    uint    upc; // Universal Product Code (UPC), generated by the Fisherman, goes on the package, can be verified by the Restaurant
    address payable ownerID;  // Metamask-Ethereum address of the current owner as the product moves through different stages
    address originFishermanID; // Metamask-Ethereum address of the Fisherman
    string  originCoastLocation;  // Coast Location - Latitude & Longitude
    string  tunaNotes; // Tuna Notes
    uint    tunaPrice; // Tuna Price
    State   tunaState;  // Tuna State as represented in the enum above
    address regulatorID;  // Metamask-Ethereum address of the Regulator
    string auditStatus; //Status of the audit from Regulator
    address payable restaurantID; // Metamask-Ethereum address of the Restaurant
  }

// Define a public mapping 'TunaFish' that maps the UPC to a Tuna Fish.
mapping (uint => TunaFish) tunaFish;

// Define a public mapping 'tunaHistory' that maps the UPC to an array of TxHash,
// that track its journey through the supply chain -- to be sent from DApp.
  mapping (uint => string[]) tunaHistory;

// Define events with the same state values and accept 'upc' as input argument
  event Caught(uint upc);
  event Recorded(uint upc);
  event Audited(uint upc);
  event Queried(uint upc);
  event Bought(uint upc);

  // Define a modifer that checks to see if msg.sender == owner of the contract
  /*modifier onlySupplyChainOwner() {
    require(msg.sender == supplyChainOwner,'This is not a Supply Chain Owner address');
    _;
  }
  */
  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address,'Caller verification was not successful');
    _;
  }

  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint _price) {
    require(msg.value >= _price,'Insufficient amount for the quoted price');
    _;
  }

// Define a modifier that checks the price and refunds the remaining balance
  modifier checkValue(uint _upc) {
    uint _price = tunaFish[_upc].tunaPrice;
    uint amountToReturn = msg.value - _price;
    tunaFish[_upc].restaurantID.transfer(amountToReturn);
    _;
  }

  // Define a modifier that checks if an tunaState of a upc is Caught
  modifier caught(uint _upc) {
    require(tunaFish[_upc].tunaState == State.Caught,'Tuna state is still not Caught');
    _;
  }

  // Define a modifier that checks if an tunaState of a upc is Recorded
  modifier recorded(uint _upc) {
    require(tunaFish[_upc].tunaState == State.Recorded,'Tuna state is still not Recorded');
    _;
  }

// Define a modifier that checks if an tunaState of a upc is Audited
  modifier audited(uint _upc) {
    require(tunaFish[_upc].tunaState == State.Audited,'Tuna state is still not Audited');
    _;
  }

  // Define a modifier that checks if an tunaState of a upc is Bought
  modifier bought(uint _upc) {
    require(tunaFish[_upc].tunaState == State.Bought,'Tuna state is still not Bought');
    _;
  }

  // In the constructor set 'owner' to the address that instantiated the contract
  // and set 'sku' to 1
  // and set 'upc' to 1
  constructor() public payable {
    //supplyChainOwner = msg.sender;
    sku = 1;
    upc = 1;
  }

  // Define a function 'kill' if required
  // function kill() public onlySupplyChainOwner() {
  //   if (msg.sender == supplyChainOwner) {
  //     selfdestruct(msg.sender);
  //   }
  // }

// Define a function 'catchTuna' that allows a Fisherman to mark an item 'Caught'
function catchTuna(uint _upc, address _originFishermanID, string memory _originCoastLocation) public
onlyFisherman()
{
    // Add the new item
  tunaFish[_upc] = TunaFish({
    upc: _upc,
    sku: sku,
    ownerID: msg.sender,
  originFishermanID: _originFishermanID,
  originCoastLocation: _originCoastLocation,
  tunaNotes: "",
  tunaPrice:0,
  tunaState: defaultState,
  regulatorID: address(0),
  auditStatus: "",
  restaurantID: address(0)
  });
  // Increment sku
  sku = sku+1;
  upc = upc+1;

  // Emit the appropriate event
  emit Caught(_upc);
  }

  // Define a function 'recordTuna' that allows a Fisherman to mark an item 'Recorded'
  function recordTuna(uint _upc, uint _price, string memory _tunaNotes) public
  // Call modifier to check if upc has passed previous supply chain stage
  caught(_upc)

  onlyFisherman()
  // Call modifier to verify caller of this function
  verifyCaller(tunaFish[_upc].ownerID)
  {
    // Update the appropriate fields
    //tunaFish[_upc].tunaID = _upc+sku*10000;
    tunaFish[_upc].tunaNotes = _tunaNotes;
    tunaFish[_upc].tunaPrice = _price;
    tunaFish[_upc].tunaState = State.Recorded;
    sku = sku + 1;
    // Emit the appropriate event
   emit Recorded(_upc);
  }

  // Define a function 'auditTuna' that allows a Fisherman to mark an item 'Audited'
  function auditTuna(uint _upc, string memory _auditStatus) public
  // Call modifier to check if upc has passed previous supply chain stage
  recorded(_upc)
  // Call modifier to verify caller of this function
  onlyRegulator()
  {
    // Update the appropriate fields
    tunaFish[_upc].regulatorID = msg.sender;
    tunaFish[_upc].auditStatus = _auditStatus;
    tunaFish[_upc].tunaState = State.Audited;

    // Emit the appropriate event
    emit Audited(_upc);
  }

  // Define a function 'queryTuna' that allows the Restaurant to view Tuna details
  function queryTuna(uint _upc) public
  // Call modifier to check if upc has passed previous supply chain stage
  view returns (
    address ownerID,
    string  memory originCoastLocation,
    string  memory tunaNotes,
    uint    tunaPrice,
    State tunaState,
    address regulatorID,
    string memory auditStatus
  )
  {
    return(
    tunaFish[_upc].ownerID,
    tunaFish[_upc].originCoastLocation,
    tunaFish[_upc].tunaNotes,
    tunaFish[_upc].tunaPrice,
    tunaFish[_upc].tunaState,
    tunaFish[_upc].regulatorID,
    tunaFish[_upc].auditStatus
    );
  }

  // Define a function 'buyTuna' that allows the Fisherman to mark an item 'Bought'
  // Use the above defined modifiers to check if the TunaFish is audited, if the Restaurant
  //  has paid enough and any excess ether sent is refunded back to the buyer
function buyTuna(uint _upc, uint _price) public payable
    // Call modifier to check if upc has passed previous supply chain stage
    audited(_upc)
    //Call modifier to verify the buyer
    onlyRestaurant()
    // Call modifer to check if buyer has paid enough
    paidEnough(tunaFish[_upc].tunaPrice)
    // Call modifer to send any excess ether back to buyer
    checkValue(_upc)
    {
   // Transfer money to Fisherman
    tunaFish[_upc].ownerID.transfer(_price);

    // Update the appropriate fields - ownerID, distributorID, itemState
    tunaFish[_upc].restaurantID = msg.sender;
    tunaFish[_upc].ownerID = msg.sender;
    tunaFish[_upc].tunaState = State.Bought;

    // emit the appropriate event
    emit Bought(_upc);
  }
}