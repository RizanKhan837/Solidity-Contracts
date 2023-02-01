// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

// calculate the sum of the first n terms of the expression x + x^2 + x^3 + ... + x^n
contract Expression{
    function expression(uint x, uint n) public pure returns(uint){
        uint num = 1;
        for (uint i = 1; i <= n; i++){
            num += x ** i;
        }
        return num;
    }
}