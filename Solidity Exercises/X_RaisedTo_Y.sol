// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract Power{
    function power(uint x, uint y) public pure returns(uint){
        return x ** y;
    }
}