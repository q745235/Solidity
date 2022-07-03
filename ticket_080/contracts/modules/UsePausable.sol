// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "./Permission.sol";

abstract contract UsePausable is Permission, ERC721Pausable{

    function pause() public virtual onlyRole(MANAGER_ROLE){
        _pause();
    }

    function unpause() public virtual onlyRole(MANAGER_ROLE){
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
