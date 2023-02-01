// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

// calculate the remainder of the division of two numbers
contract Remainder{
    function find(uint _a) public pure returns(uint){
        require(_a > 0 , "num must be greater");
        return _a %3;
    }
}