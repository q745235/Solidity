// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

//Not yet tested
library Probability{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Data{//{key: name, value: probability}
        EnumerableSet.Bytes32Set _items;
        mapping(bytes32 => uint) _probabilities;
    }

    function addProbability(
        Probability.Data storage data,
        string memory itemName,
        uint probability
    ) internal {
        bytes32 bytesName = toBytes32(itemName);
        data._items.add(bytesName);
        data._probabilities[bytesName] = probability;
    }

    function removeProbability(
        Probability.Data storage data,
        string memory itemName
    ) internal {
        bytes32 bytesName = toBytes32(itemName);
        data._items.remove(bytesName);
        data._probabilities[bytesName] = 0;
    }

    function getProbability(
        Probability.Data storage data,
        string memory itemName
    ) internal view returns(uint){
        EnumerableSet.Bytes32Set storage items = data._items;
        mapping(bytes32 => uint) storage probabilities = data._probabilities;
        
        uint itemsAmount = items.length();
        bytes32 bytesName = toBytes32(itemName);
        if(items.contains(bytesName)){
            uint totalValue = 0;
            uint itemValue = probabilities[bytesName];
            for (uint256 i = 0; i < itemsAmount; i++) {
                totalValue += probabilities[items.at(i)];
            }
            return itemValue*1000/totalValue;
        }else{
            return 0;
        }
    }

    function toBytes32(string memory source) private pure returns(bytes32 result){
        assembly{
            result := mload(add(source,32))
        }
    }
}