// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.6 < 0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract TimeInheritanceContract {

    using SafeMathChainlink for uint256; // Countermeasure to overflow errors resulting from uint256 math operations in early versions of solidity compiler.
    address owner;
    address child; // Address/Account that inherits control if checkin period is missed.
    uint256 deadline; // Time before check in period expires.

    constructor() public {
      owner = msg.sender; // Constructor immediately assigns msg.sender or contract deployer as owner; this is an important security measure.
      child = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; // Change address to whichever account you would like to add in this role.
    }

    modifier onlyOwner() { // This modifier authorizes only the owner of the contract to execute whichever function utilizes this modifier.
        require(msg.sender == owner);
        _;
    }

    modifier onlyChild{ // This modifier authorizes only the "child" account/address of the contract to execute whichever function utilizes this modifier.
      require(msg.sender == child);
      _;
    }

    function fundMe() public payable {
        uint256 minimumUSD = 1 * 10 ** 18; // Anyone can make a payment of atleast this much eth to the contract.
        require(getConversionRate(msg.value) >= minimumUSD, "More Eth tokens needed");
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
         return uint256(answer * 10000000000);
    }
    
     // 1000000000
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function withdraw() public payable onlyOwner  { // Only owner or "parent" account uses this withdraw function.
        msg.sender.transfer(address(this).balance);
    }

    function specialWithdraw() public payable onlyChild { // Only child account uses this.
       require(now >= deadline, "Deadline not yet up!"); // Will improve this to make specific withdrawal amount.
       msg.sender.transfer(address(this).balance); 
    }

     function setCheckInDate(uint256 numberOfMins) public onlyOwner { //Sets check in date by specifying number of minutes until next check in.  
        deadline = now + (numberOfMins * 1 minutes); // The function can be made more practical by using a larger time unit eg. 1 days, 1 months, 1 years etc.
    }

    function getTimeRemaining() public view returns (uint256){
      if (deadline <= now){ // Checks to see if its time to check in.
        return 0;
      } else {
        return deadline - now; // Returns amount of seconds remaining until next check in.
      } 
    }

}
