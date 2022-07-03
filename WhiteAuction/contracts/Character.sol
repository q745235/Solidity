// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Miner.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Character is Miner, ERC721 {
    using Counters for Counters.Counter;

    struct CharacterInfo{
        uint8 HPbase;
        uint8 ATKbase;
        uint8 DEFbase;
        uint8 LUKbase;
    }

    mapping (uint => CharacterInfo) private _characterInfo;
    mapping (uint => uint) private _characterIndex; //tokenId => characterIndex
    
    mapping (uint => Counters.Counter) private _nftCount; //characterIndex => count
    mapping (uint => string) private _characterURI; //characterIndex => URI;

    constructor() public ERC721("q745235 Character", "NFTCharacter") {}

    function characterCount(uint characterIndex) public view returns(uint){
        return _nftCount[characterIndex].current();
    }

    function tokenInfo(uint tokenId) public view returns(CharacterInfo memory){
        return _characterInfo[tokenId];
    }

    function tokenId2Character(uint tokenId) public view returns(uint){
        return _characterIndex[tokenId];
    }

    function mint(
        address recipient,
        uint characterIndex,
        CharacterInfo memory characterInfo
    ) external onlyMiner{

        uint tokenId = characterIndex.mul(1000).add(characterCount(characterIndex));
        
        _characterInfo[tokenId] = characterInfo;
        _characterIndex[tokenId] = characterIndex;
        _mint(recipient, tokenId);
        _nftCount[characterIndex].increment();
    }

    function burn(uint tokenId) external{
        require(ownerOf(tokenId) == msg.sender, "You are not this token owner");
        _burn(tokenId);
    }

    function characterURI(uint characterIndex) public view returns(string memory) {
        return _characterURI[characterIndex];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        uint characterIndex = tokenId2Character(tokenId);

        string memory base = baseURI();
        
        // If there is no base URI, return the character URI.
        if (bytes(base).length == 0) {
            return characterURI(characterIndex);
        }
        // If both are set, concatenate the baseURI and characterURI (via abi.encodePacked).
        if (bytes(characterURI(characterIndex)).length > 0) {
            return string(abi.encodePacked(base, characterURI(characterIndex)));
        }
        // If there is a baseURI but no characterURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setCharacterURI(uint characterIndex, string memory URI) external onlyOwner{
        _characterURI[characterIndex] = URI;
    }
}