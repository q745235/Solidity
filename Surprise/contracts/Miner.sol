// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Miner is  Ownable{
    mapping(address => bool) public isMiner;

    modifier onlyMiner() {
        require(isMiner[msg.sender], "Mine: caller is not the miner");
        _;
    }

    function setMiner(address _miner) public onlyOwner{
        isMiner[_miner] = true;
    }

    function delMiner(address _miner) public onlyOwner{
        isMiner[_miner] = false;
    }

    constructor() public{
        setMiner(msg.sender);
    }
}