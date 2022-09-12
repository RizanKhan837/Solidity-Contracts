// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract LocalVar{
    uint256 num = 10;  // 2**256
    function returnStateVariable() public view returns(uint){
        return num;
    }
    function returnLocalVariable() public pure returns(uint24){
        uint24 num1 = 20;  // 2**24
        return num1;
    }
}