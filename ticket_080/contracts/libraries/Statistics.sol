// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Convert.sol";

library Statistics{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Data{
        EnumerableSet.Bytes32Set _items;
        mapping(bytes32 => uint) _amount;
    }

    function addAmount(
        Statistics.Data storage data,
        string memory itemName,
        uint amount
    ) internal {
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(!data._items.contains(bytesName)){
            data._items.add(bytesName);
        }
        data._amount[bytesName] += amount;
    }

    function getLength(
        Statistics.Data storage data
    ) internal view returns(uint){
        return data._items.length();
    }

    function getItems(
        Statistics.Data storage data
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
        Statistics.Data storage data,
        string memory itemName
    ) internal view returns(uint){
        bytes32 bytesName = Convert.stringToBytes32(itemName);
        if(data._items.contains(bytesName)){
            return data._amount[bytesName];
        }
        return 0;
    }

}