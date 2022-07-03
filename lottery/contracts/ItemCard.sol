// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Miner.sol';
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/utils/Counters.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/*
    Item Quality:
    R: 1
    B: 2
    A: 3
    S: 4
    SR: 5
    Lengend: 6
*/
    
contract ItemCard is Miner, ERC721 {
    using Counters for Counters.Counter;

    struct ItemInfo{
        uint8 x1;
        uint8 x2;
        uint8 y1;
        uint8 y2;
        uint8 z1;
        uint8 z2;
    }

    mapping (uint => ItemInfo) private _itemInfo; //tokenId => info
    mapping (uint => uint) private _itemIndex; //tokenId => itemIndex
    mapping (uint => uint8) private _itemQuality; //tokenId => itemQuality
    
    mapping (uint => mapping (uint8 => Counters.Counter)) private _nftCount; //itemIndex => count
    mapping (uint => mapping(uint8 => string)) private _itemURI; //itemIndex => URI;

    constructor() public ERC721("NFTs Battle Item Card", "NFTSKILL") {}

    function itemCount(uint itemIndex, uint8 itemQuality) public view returns(uint){
        return _nftCount[itemIndex][itemQuality].current();
    }

    function tokenInfo(uint tokenId) public view returns(ItemInfo memory){
        return _itemInfo[tokenId];
    }

    function tokenId2Item(uint tokenId) public view returns(uint){
        return _itemIndex[tokenId];
    }

    function tokenId2Quality(uint tokenId) public view returns(uint8){
        return _itemQuality[tokenId];
    }

    function mint(address recipient, uint itemIndex, uint8 itemQuality,
        ItemInfo memory itemInfo) external onlyMiner{
        require(itemQuality <= 6 && itemQuality > 0, "Item Card: itemQuality error");
        uint tokenId = itemIndex.mul(10000).add(uint(itemQuality).mul(1000)).add(itemCount(itemIndex, itemQuality));
        _itemInfo[tokenId] = itemInfo;
        _itemIndex[tokenId] = itemIndex;
        _itemQuality[tokenId] = itemQuality;
        _mint(recipient, tokenId);
        _nftCount[itemIndex][itemQuality].increment();
    }

    function burn(uint tokenId) external{
        require(ownerOf(tokenId) == msg.sender, "You are not this token owner");
        _burn(tokenId);
    }

    function itemURI(uint itemIndex, uint8 quality) public view returns(string memory) {
        return _itemURI[itemIndex][quality];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        uint itemIndex = tokenId2Item(tokenId);
        uint8 itemQuality = tokenId2Quality(tokenId);

        string memory base = baseURI();

        // If there is no base URI, return the item URI.
        if (bytes(base).length == 0) {
            return itemURI(itemIndex, itemQuality);
        }
        // If both are set, concatenate the baseURI and itemURI (via abi.encodePacked).
        if (bytes(itemURI(itemIndex, itemQuality)).length > 0) {
            return string(abi.encodePacked(base, itemURI(itemIndex, itemQuality)));
        }
        // If there is a baseURI but no itemURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setItemURI(uint itemIndex, uint8 quality, string memory URI) external onlyOwner{
        _itemURI[itemIndex][quality] = URI;
    }
}