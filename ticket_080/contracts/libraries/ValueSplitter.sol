// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library ValueSplitter{
    using EnumerableSet for EnumerableSet.AddressSet;
    
    struct List{
        EnumerableSet.AddressSet wallets;
        mapping (address => uint) splitters;
    }

    function setSplitter(
        List storage list,
        uint[] memory splitters,
        address[] memory wallets
    ) internal{
        require(
            wallets.length == splitters.length,
            "Sharing: the wallets length have to equal splitters"
        );
        uint length = splitters.length;
        for (uint256 i = 0; i < length; i++) {
            address wallet = wallets[i];
            if(list.wallets.contains(wallet)){
                list.splitters[wallet] = splitters[i];
            }
            list.wallets.add(wallet);
            list.splitters[wallet] = splitters[i];
        }
    }

    function allWallets(
        List storage list
    ) internal view returns(address[] memory){
        return list.wallets.values();
    }

    function feeByWallet(
        List storage list, address wallet
    ) internal view returns(uint){
        return list.splitters[wallet];
    }

    function actualFeeByWallet(
        List storage list, uint price, address wallet
    ) internal view returns(uint){
        return getActualFee(price, feeByWallet(list, wallet));
    }

    function allActualFee(
        List storage list, uint price
    ) internal view returns(uint){
        uint actualFee = 0;
        address[] memory wallets = allWallets(list);
        for (uint256 i = 0; i < wallets.length; i++) {
            address wallet = wallets[i];
            actualFee += actualFeeByWallet(list, price, wallet);
        }
        return actualFee;
    }

    function getActualFee(
        uint price, uint permillage
    )internal pure returns(uint){
        return price/1000*permillage;
    }

}