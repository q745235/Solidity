// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Permission.sol";

abstract contract Withdraw is Permission{

    function _withdrawEth(address to, uint value) private{
        payable(to).transfer(value);
    }

    function _withdrawToken(IERC20 tokenContract, address to, uint value) private{
        tokenContract.transfer(to, value);
    }

    function withdrawEth() external onlyRole(DEFAULT_ADMIN_ROLE){
        _withdrawEth(_msgSender(), address(this).balance);
    }

    function withdrawEth(uint value) external onlyRole(DEFAULT_ADMIN_ROLE){
        _withdrawEth(_msgSender(), value);
    }

    function withdrawToken(
        IERC20 tokenContract
    ) external onlyRole(DEFAULT_ADMIN_ROLE){
        _withdrawToken(
            tokenContract,
            _msgSender(),
            tokenContract.balanceOf(address(this))
        );
    }

    function withdrawToken(
        IERC20 tokenContract,
        uint value
    ) external onlyRole(DEFAULT_ADMIN_ROLE){
        _withdrawToken(
            tokenContract,
            _msgSender(),
            value
        );
    }

}
