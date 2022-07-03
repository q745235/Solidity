// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20 {
    constructor() public ERC20("Ray USDT", "USDT") {
        _mint(msg.sender, 1000000e18);
    }
}