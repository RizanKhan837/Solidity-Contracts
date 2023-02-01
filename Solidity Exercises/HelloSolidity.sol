// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.12;

// print the string "Hello Solidity"
contract HelloSolidity{
    string str = "Hello Solidity";
    function print() public view returns(string memory){
        return str;
    }
}