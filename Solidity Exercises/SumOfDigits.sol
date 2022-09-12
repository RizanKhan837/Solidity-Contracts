// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

contract SumOfDigits{
    
    function digitSum(uint num) public pure returns(uint){
        uint sum = 0;
        while(num > 0)
        {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }
}