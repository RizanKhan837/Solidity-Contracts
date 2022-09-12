// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract Remainder{
    function find(uint _a) public pure returns(uint){
        require(_a > 0 , "num must be greater");
        return _a %3;
    }
}