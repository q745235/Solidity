// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";

abstract contract WhiteList is Permission{

    mapping(address => bool) public isInWhiteList;
    mapping(address => bool) public isBought;

    event AddWhiteList(address targetAddress);
    event RemoveWhiteList(address targetAddress);

    function addWhiteList(
        address targetAddress
    ) external onlyRole(MANAGER_ROLE){
        isInWhiteList[targetAddress] = true;
        emit AddWhiteList(targetAddress);
    }

    function batchAddWhiteList(
        address[] memory targetAddresses
    ) external onlyRole(MANAGER_ROLE){
        for (uint256 i = 0; i < targetAddresses.length; i++) {
            isInWhiteList[targetAddresses[i]] = true;
            emit AddWhiteList(targetAddresses[i]);
        }
    }

    function removeWhiteList(
        address targetAddress
    ) external onlyRole(MANAGER_ROLE){
        isInWhiteList[targetAddress] = false;
        emit RemoveWhiteList(targetAddress);
    }

    function batchRemoveWhiteList(
        address[] memory targetAddresses
    ) external onlyRole(MANAGER_ROLE){
        for (uint256 i = 0; i < targetAddresses.length; i++) {
            isInWhiteList[targetAddresses[i]] = false;
            emit RemoveWhiteList(targetAddresses[i]);
        }
    }

    function _setBought(address account) internal{
        isBought[account] = true;
    }

    modifier checkisBought(){
        require(
            !isBought[_msgSender()],
            "WhiteList: already have bought"
        );
        _;
    }

    modifier checkInWhiteList(){
        require(
            isInWhiteList[_msgSender()],
            "WhiteList: must be in whiteList"
        );
        _;
    }

}