// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";

abstract contract MultiPurchaseTime is Permission{

    mapping(uint => PurchaseTime) public purchaseTimes;
    //group => PurchaseTime

    struct PurchaseTime{
        uint start;
        uint end;
    }

    function setPurchaseTime(
        uint group,
        uint startTime,
        uint endTime
    ) external onlyRole(MANAGER_ROLE){
        _setPurchaseTime(group, startTime, endTime);
    }

    function _setPurchaseTime(
        uint group,
        uint startTime,
        uint endTime
    ) internal{
        purchaseTimes[group] = PurchaseTime({
            start: startTime,
            end: endTime
        });
    }

    modifier checkInTime(uint group){
        PurchaseTime storage purchaseTime = purchaseTimes[group];

        require(
            purchaseTime.start != 0 &&
            purchaseTime.end != 0,
            "SellTime: purchaseTime is not correct"
        );
        require(
            block.timestamp > purchaseTime.start &&
            purchaseTime.end > block.timestamp,
            "SellTime: It is not in sale time"
        );
        _;
    }

}