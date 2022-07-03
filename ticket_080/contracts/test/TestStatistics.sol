// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "../libraries/Statistics.sol";
import "hardhat/console.sol";

contract TestStatistics{

    using Statistics for Statistics.Data;
    Statistics.Data private statistics;

    function addAmount(string memory itemName, uint amount) external{
        statistics.addAmount(itemName, amount);
    }

    function getLength() external view returns(uint){
        return statistics.getLength();
    }

    function getItems() external view returns(string[] memory){
        return statistics.getItems();
    }

    function getAmount(string memory itemName) external view returns(uint){
        return statistics.getAmount(itemName);
    }
}

