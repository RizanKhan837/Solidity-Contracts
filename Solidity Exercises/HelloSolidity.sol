// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

contract HelloSolidity{
    string str = "Hello Solidity";
    function print() public view returns(string memory){
        return str;
    }
}