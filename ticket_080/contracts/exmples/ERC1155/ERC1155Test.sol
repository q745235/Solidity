// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "../../modules/Permission.sol";

/**
Features:
    Mint: YES
    Manager: YES, Multilayer(Admin, Manager, Minter)
    Pausable: YES
    Burn: YES
    TokenURI: YES
    TokenName: YES
 */

contract ERC1155Test is 
    Context,
    ERC1155Burnable,
    ERC1155Pausable,
    Permission
{
    mapping(uint => string) public tokenName;

    /**
    Use the same uri, like https://game.example/api/item/{id}.json
     */
    constructor() ERC1155("https://example.com") {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155, ERC1155Pausable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    //==============MINTER ONLY==============
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual onlyRole(MINTER_ROLE){
        _mint(to, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual onlyRole(MINTER_ROLE){
        _mintBatch(to, ids, amounts, data);
    }

    //==============MANAGER ONLY==============

    function setTokenName(
        uint tokenId,
        string memory newTokenName
    ) public onlyRole(MANAGER_ROLE){
        tokenName[tokenId] = newTokenName;
    }

    function pause() public onlyRole(MANAGER_ROLE){
        _pause();
    }

    function unpause() public onlyRole(MANAGER_ROLE){
        _unpause();
    }

}
