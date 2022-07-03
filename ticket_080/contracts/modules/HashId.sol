// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HashId{

    using Strings for uint;

    string private privateWord;

    constructor(string memory _privateWord){
        privateWord = _privateWord;
    }

    function _getHashByPrivateWord(
        uint id
    ) internal view returns(string memory){
        uint originUintHash = uint(keccak256(
            abi.encodePacked("q745235", id, privateWord) 
        ));
        return(originUintHash/10**40).toString();
    }

}