// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "../libraries/DutchAuction.sol";
import "hardhat/console.sol";

contract TestDutchAuction2{
    using DutchAuction for DutchAuction.Data;

    DutchAuction.Data private sale;
    function newSale(
        uint interval,
        uint startTime,
        uint startPrice,
        uint decrease
    ) external {

        sale.set(
            interval,
            startTime,
            startPrice,
            decrease
        );
    }

    function getPrice() external view returns(uint) {
        return sale.getPrice();
    }

}