// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract ReverseNum{

    function Reverse(uint num) public pure returns(uint){
        uint rem = 0;
        uint rev = 0;
        while (num > 0){
            rev = num%10;
            rem = rem * 10 + rev;
            num /= 10;
        }
        return rem;
    }
}