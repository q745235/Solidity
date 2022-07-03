// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "../../modules/Permission.sol";

/**
Features:
    Mint: YES
    Manager: YES, Multilayer(Admin, Manager, Minter)
    Pausable: YES
    Burn: YES
 */

contract ERC20Pro is 
    Context,
    ERC20Burnable,
    ERC20Pausable,
    Permission
{
    constructor(
        uint256 initialSupply,
        string memory name,
        string memory symbol
    )ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) onlyRole(MINTER_ROLE) external{
        _mint(to, amount);
    }
    
    function pause() external onlyRole(MANAGER_ROLE){
        _pause();
    }

    function unpause() external onlyRole(MANAGER_ROLE){
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
