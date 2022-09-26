// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract SumOfArray{
    function sumOfArray(uint[] memory arrays, uint len) public pure returns(uint){
        uint num = 0;
        for (uint i = 0; i < len; i++){
            num += arrays[i];
        }
        return num;
    }
}