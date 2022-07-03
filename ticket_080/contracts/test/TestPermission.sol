// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "hardhat/console.sol";
import "../modules/Permission.sol";

contract TestPermission is Permission{
    function mint() external onlyRole(MINTER_ROLE) view{
        // require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");
        console.log("TestPermission: mint success");
    }
}