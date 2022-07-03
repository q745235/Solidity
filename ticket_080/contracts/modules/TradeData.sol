// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

abstract contract TradeData{

    mapping (address => uint) public volumeTraded;
    //已交易量, NFT Contract => volume
    mapping (address => uint) public itemCountTraded;
    //已交易數, Contract => itemCount
    
    function _addVolumeTraded(address nftContract, uint volume) internal{
        volumeTraded[nftContract] += volume;
    }

    function _addItemCountTraded(address nftContract) internal{
        itemCountTraded[nftContract]++;
    }
}
