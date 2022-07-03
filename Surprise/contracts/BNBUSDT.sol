// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract BNBUSDT {
  uint public _BNB = 5e18;
  uint public _USDT = 2500e18;

  function BNB() public view returns(uint) {
    return _BNB;
  }

  function USDT() public view returns(uint) {
    return _USDT;
  }
}
