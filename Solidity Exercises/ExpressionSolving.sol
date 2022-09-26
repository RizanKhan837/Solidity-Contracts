// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract Expression{
    function expression(uint x, uint n) public pure returns(uint){
        uint num = 1;
        for (uint i = 1; i <= n; i++){
            num += x ** i;
        }
        return num;
    }
}