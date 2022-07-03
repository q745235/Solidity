// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../modules/Permission.sol";

/**
Features:
    Mint: YES
    Manager: YES, Multilayer(Admin, Manager, Minter)
    Pausable: YES
    Burn: YES
    TokenURI: YES
    Batch Mint: YES
 */


//可加上batch mint
contract ERC721Pro is
    Context,
    Permission,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721Pausable,
    ERC721URIStorage
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    string private _baseTokenURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

//only minter

    function mintBatch(
        address[] memory recipients,
        string[] memory tokenUris
    ) external onlyRole(MINTER_ROLE){
        require(
            recipients.length == tokenUris.length,
            "MyERC721: the length of recipients must be equal to tokenUris"
        );
        for(uint i = 0; i < recipients.length; i++){
            _mintToken(recipients[i], tokenUris[i]);
        }
    }

    function mintBatch(
        address[] memory recipients,
        string memory tokenUri
    ) external onlyRole(MINTER_ROLE){
        for(uint i = 0; i < recipients.length; i++){
            _mintToken(recipients[i], tokenUri);
        }
    }

    function mint(address recipient, string memory tokenUri) public virtual onlyRole(MINTER_ROLE){
        _mintToken(recipient, tokenUri);
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
    function _mintToken(address recipient, string memory tokenUri) internal{
        _tokenIdTracker.increment();
        _mint(recipient, _tokenIdTracker.current());
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
