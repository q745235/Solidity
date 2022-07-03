// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Random {
 
    uint256 internal randomSeed;
    
    function _getRandomNumber() internal returns (uint){
        _updateRamdomSeed();
        return uint(keccak256(abi.encodePacked(
            randomSeed, now, msg.sender
        )));
    }

    function _updateRamdomSeed() private {
        randomSeed++;
    }

}