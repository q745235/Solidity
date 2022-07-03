// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Permission.sol";
import "./PayUsdt.sol";
import "../libraries/ValueSplitter.sol";

abstract contract ProjectFee is PayUsdt, Permission{
    using ValueSplitter for ValueSplitter.List;

    mapping(address => ValueSplitter.List) private _fees;

    function setFees(
        address tokenAddress,
        uint[] memory fees,
        address[] memory wallets
    ) external onlyRole(MANAGER_ROLE){
        _fees[tokenAddress].setSplitter(fees, wallets);
    }

    function _BuyerPayUsdt(
        address tokenAddress, address seller, uint price
    ) internal{
        ValueSplitter.List storage feeList = _fees[tokenAddress];
        uint allFee = feeList.allActualFee(price);
        uint sellIncome = price - allFee;

        address[] memory wallets = feeList.allWallets();
        
        for (uint256 i = 0; i < wallets.length; i++) {
            if(wallets[i] != address(0)){
                _contractPayUsdt(
                    wallets[i],
                    feeList.actualFeeByWallet(price, wallets[i])
                );
            }
        }   
        _contractPayUsdt(seller, sellIncome);
    }

    function _BuyerPayBnb(
        address tokenAddress, address seller, uint price
    ) internal{
        ValueSplitter.List storage feeList = _fees[tokenAddress];
        uint allFee = feeList.allActualFee(price);
        uint sellIncome = price - allFee;

        address[] memory wallets = feeList.allWallets();
        
        for (uint256 i = 0; i < wallets.length; i++) {
            if(wallets[i] != address(0)){
                payable(wallets[i]).transfer(
                    feeList.actualFeeByWallet(price, wallets[i])
                ); 
            }
        }

        payable(seller).transfer(sellIncome);
    }
}
