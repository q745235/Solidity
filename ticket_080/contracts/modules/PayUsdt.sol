// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

abstract contract PayUsdt is Context{
    
    using SafeERC20 for IERC20;

    IERC20 public usdtContract;

    function _setUsdtContract(IERC20 _usdtContract) internal {
        usdtContract = _usdtContract;
    }

    function _senderPayUsdt(address to, uint value) internal {
        require(
            address(usdtContract) != address(0),
            "PayUsdt: usdt address is null"
        );
        usdtContract.safeTransferFrom(
            _msgSender(), to, value
        );
    }

    function _contractPayUsdt(address to, uint value) internal {
        require(
            address(usdtContract) != address(0),
            "PayUsdt: usdt address is null"
        );
        usdtContract.safeTransfer(to, value);
    }
}