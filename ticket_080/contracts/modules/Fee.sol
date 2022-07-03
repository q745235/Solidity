// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";
import "./PayUsdt.sol";
import "../libraries/ValueSplitter.sol";

contract Fee is PayUsdt, Permission{
    using ValueSplitter for ValueSplitter.List;

    ValueSplitter.List internal _fees;

    function getAllWallet() external view returns(address[] memory){
        return _fees.allWallets();
    }

    function getFeeByWallet(address wallet) external view returns(uint){
        return _fees.feeByWallet(wallet);
    }

    function setUsdtContract(
        IERC20 _usdtContract
    ) external onlyRole(MANAGER_ROLE){
        _setUsdtContract(_usdtContract);
    }

    function setFees(
        uint[] memory fees,
        address[] memory wallets
    ) external onlyRole(MANAGER_ROLE){
        _fees.setSplitter(fees, wallets);
    }

    function _BuyerPayUsdt(uint price) internal{
        _BuyerPayUsdt(address(this), price);
    }

    function _BuyerPayBnb(uint price) internal{
        _BuyerPayBnb(address(this), price);
    }

    function _BuyerPayUsdt(
        address seller, uint price
    ) internal{
        uint allFee = _fees.allActualFee(price);
        uint sellIncome = price - allFee;

        address[] memory wallets = _fees.allWallets();
        _senderPayUsdt(address(this), price);
        for (uint256 i = 0; i < wallets.length; i++) {
            if(wallets[i] != address(0)){
                _contractPayUsdt(
                    wallets[i],
                    _fees.actualFeeByWallet(price, wallets[i])
                );
            }
        }   
        _contractPayUsdt(seller, sellIncome);
    }

    function _BuyerPayBnb(
        address seller, uint price
    ) internal{
        uint allFee = _fees.allActualFee(price);
        uint sellIncome = price - allFee;

        address[] memory wallets = _fees.allWallets();
        
        for (uint256 i = 0; i < wallets.length; i++) {
            if(wallets[i] != address(0)){
                payable(wallets[i]).transfer(
                    _fees.actualFeeByWallet(price, wallets[i])
                ); 
            }
        }

        payable(seller).transfer(sellIncome);
    }

}
