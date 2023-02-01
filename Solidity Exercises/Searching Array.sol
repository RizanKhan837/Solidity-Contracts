// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

// search for an element in an array
contract Search{
	function search(uint[] memory array, uint len, uint element) public pure returns (uint){
        uint num;
        for (uint i = 0; i < len; i++){
            if (element == array[i]){
                num = 1;
                break;
            }else{
                num = 0;
            }
        }
        return num;
    }
}