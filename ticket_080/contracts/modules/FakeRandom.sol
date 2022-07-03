// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

abstract contract FakeRandom {
 
    uint256 internal randomSeed;
    
    function _getRandomNumber() internal returns (uint){
        _updateRamdomSeed();
        return uint(keccak256(abi.encodePacked(
            randomSeed, block.timestamp, msg.sender
        )));
    }

    function _updateRamdomSeed() private {
        randomSeed++;
    }

}