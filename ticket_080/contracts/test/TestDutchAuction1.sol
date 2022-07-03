// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "../libraries/DutchAuction.sol";
import "hardhat/console.sol";

contract TestDutchAuction1{
    using DutchAuction for DutchAuction.Data;

    DutchAuction.Data private sale;
    function newSale(
        uint startTime,
        uint endTime,
        uint startPrice,
        uint endPrice,
        uint interval
    ) external {

        sale.set(
            interval,
            startTime,
            startPrice,
            endTime,
            endPrice
        );
    }

    function getPrice() external view returns(uint) {
        return sale.getPrice();
    }

}