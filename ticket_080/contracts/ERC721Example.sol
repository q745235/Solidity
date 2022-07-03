// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./modules/Permission.sol";
import "./modules/HashId.sol";
import "hardhat/console.sol";

//Just test, Don't use it
contract ERC721Example is
    Context,
    Permission,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721Pausable,
    ERC721URIStorage,
    HashId("aaa")
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    string private _baseTokenURI;
    mapping(address => bool) public approveWhiteList;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage, ERC721) returns (string memory) {
        string memory _tokenURI = super.tokenURI(tokenId);
        console.log("tokenURI:", _tokenURI);
        return _tokenURI;
    }

    function approve(
        address to, uint256 tokenId
    ) public override(ERC721, IERC721){
        require(approveWhiteList[to], "ERC721: the address approve of having to on whiteList");
        super.approve(to, tokenId);
    }

    function setApprovalForAll(
        address operator, bool approved
    ) public override(ERC721, IERC721){
        require(approveWhiteList[operator], "ERC721: the address approve of having to on whiteList");
        super.setApprovalForAll(operator, approved);
    }

//only minter

    function mintBatch(
        address[] memory recipients
    ) external onlyRole(MINTER_ROLE){
        for(uint i = 0; i < recipients.length; i++){
            _mintToken(recipients[i]);
        }
    }

    function mint(address recipient) public virtual onlyRole(MINTER_ROLE){
        _mintToken(recipient);
    }

//only manager
    function setBaseURI(string memory baseURI) external onlyRole(MANAGER_ROLE){
        _baseTokenURI = baseURI;
    }

    function pause() public virtual onlyRole(MANAGER_ROLE){
        _pause();
    }

    function unpause() public virtual onlyRole(MANAGER_ROLE){
        _unpause();
    }

//overwrite
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }

//other
    function _mintToken(address recipient) internal{
        _tokenIdTracker.increment();
        _mint(recipient, _tokenIdTracker.current());
        string memory tokenUri = _getHashByPrivateWord(_tokenIdTracker.current());
        console.log("tokenUri:", tokenUri);
        _setTokenURI(_tokenIdTracker.current(), tokenUri);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
