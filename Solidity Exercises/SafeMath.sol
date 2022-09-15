// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract SafeMath{

    // After Version 0.8 The Auto Check If You're Goinmg To Overflow or Under Flow
    uint8 public bigNum = 255; 

    function addBigNum() public{
        unchecked{bigNum++;}  // It'll Revert Back To Zero
    }
}

