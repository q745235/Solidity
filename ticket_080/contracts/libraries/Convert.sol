// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

library Convert{

    function stringToBytes32(string memory source) internal pure returns(bytes32 result){
        assembly{
            result := mload(add(source,32))
        }
    }

    function bytes32ToString(bytes32 x) internal pure returns(string memory){
        bytes memory bytesString = new bytes(32);
        uint charCount = 0 ;
        for(uint j=0; j<32; j++){
            unchecked {
              bytes1 char = bytes1(bytes32(uint(x) *2 **(8*j)));
                if(char !=0){
                    bytesString[charCount] = char;
                    charCount++;
                }  
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for(uint j=0; j < charCount; j++){
            bytesStringTrimmed[j]=bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}