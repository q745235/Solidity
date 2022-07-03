// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Miner.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ItemCardPack is Miner, ERC721 {
    using Counters for Counters.Counter;

    mapping (uint => Counters.Counter) private _nftCount; //itemPackIndex => count
    mapping (uint => string) private _itemPackURI; //itemPackIndex => URI;
    mapping (uint => uint) private _packIndex; //itemPackIndex => URI;

    constructor() public ERC721("NFTs Battle Item Card Pack", "NFTPack") {}

    function itemCount(uint itemPackIndex) public view returns(uint){
        return _nftCount[itemPackIndex].current();
    }

    function token2Pack(uint tokenId) public view returns(uint){
        return _packIndex[tokenId];
    }

    function mint(address recipient, uint itemPackIndex) external onlyMiner{
        //Item Id = Item Index * 1000 + counter
        uint tokenId = itemPackIndex.mul(1000).add(itemCount(itemPackIndex));
        _mint(recipient, tokenId);
        _packIndex[tokenId] = itemPackIndex;
        _nftCount[itemPackIndex].increment();
    }

    function itemPackURI(uint itemPackIndex) public view returns(string memory) {
        return _itemPackURI[itemPackIndex];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        uint itemPackIndex = token2Pack(tokenId);

        string memory base = baseURI();

        // If there is no base URI, return the item URI.
        if (bytes(base).length == 0) {
            return itemPackURI(itemPackIndex);
        }
        // If both are set, concatenate the baseURI and itemURI (via abi.encodePacked).
        if (bytes(itemPackURI(itemPackIndex)).length > 0) {
            return string(abi.encodePacked(base, itemPackURI(itemPackIndex)));
        }
        // If there is a baseURI but no itemPackURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setItemURI(uint itemPackIndex, string memory URI) external onlyOwner{
        _itemPackURI[itemPackIndex] = URI;
    }
}