// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract Difference{
    function max(int a, int b)public pure returns (int) {
        return a >= b ? a : b;    
    }    
    function min(int a, int b)public pure returns (int) { 
        return a < b ? a : b;   
    }

    function evaluate(int a, int b) public pure returns(int){
        int sum = a + b;
        int maxNum = max(a, b);
        int minNum = min(a, b);
        int diff = maxNum - minNum;
        int result = sum - diff;
        return result;
    }
}