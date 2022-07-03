// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Convert.sol";

library StatisticsLimited{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Data{
        EnumerableSet.Bytes32Set _items;
        mapping(bytes32 => uint) _amount;
        mapping(bytes32 => uint) _limited;
    }

    function setLimited(
        StatisticsLimited.Data storage data,
        string memory itemName,
        uint limited
    ) internal {
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(!data._items.contains(bytesName)){
            data._items.add(bytesName);
        }
        data._limited[bytesName] = limited;
    }

    function addAmount(
        StatisticsLimited.Data storage data,
        string memory itemName,
        uint amount
    ) internal {
        bytes32 bytesName = Convert.stringToBytes32(itemName);

        require(
            data._amount[bytesName] + amount <= data._limited[bytesName], 
            "StatisticsLimited: cannot over than limited"
        );
        data._amount[bytesName] += amount;
    }

    function setAmount(
        StatisticsLimited.Data storage data,
        string memory itemName,
        uint Amount
    ) internal {
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(!data._items.contains(bytesName)){
            data._items.add(bytesName);
        }
        data._amount[bytesName] = Amount;
    }

    function getLength(
        StatisticsLimited.Data storage data
    ) internal view returns(uint){
        return data._items.length();
    }

    function getItems(
        StatisticsLimited.Data storage data
    ) internal view returns(string[] memory){
        uint length = data._items.length();
        string[] memory res = new string[](length);
        for (uint256 i = 0; i < length; i++) {
            bytes32 bytesName = data._items.at(i);
            res[i] = (Convert.bytes32ToString(bytesName));
        }
        return res;
    }

    function getAmount(
        StatisticsLimited.Data storage data,
        string memory itemName
    ) internal view returns(uint){
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(data._items.contains(bytesName)){
            return data._amount[bytesName];
        }
        return 0;
    }

    function getLimited(
        StatisticsLimited.Data storage data,
        string memory itemName
    ) internal view returns(uint){
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(data._items.contains(bytesName)){
            return data._limited[bytesName];
        }
        return 0;
    }

}