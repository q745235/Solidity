// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";

abstract contract PurchaseTime is Permission{
    uint public purchaseStartTime;
    uint public purchaseEndTime;

    function setPurchaseTime(
        uint startTime, uint endTime
    ) external onlyRole(MANAGER_ROLE){
        _setPurchaseTime(startTime, endTime);
    }

    function _setPurchaseTime(
        uint startTime, uint endTime
    ) internal{
        purchaseStartTime = startTime;
        purchaseEndTime = endTime;
    }

    modifier checkInTime(){
        require(
            purchaseStartTime != 0 &&
            purchaseEndTime != 0,
            "SellTime: purchaseTime is not correct"
        );
        require(
            block.timestamp > purchaseStartTime &&
            purchaseEndTime > block.timestamp,
            "SellTime: It is not in sale time"
        );
        _;
    }

}