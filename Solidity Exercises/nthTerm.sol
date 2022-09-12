// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

contract nthTerm{
 
    function nthTerm(uint _n, uint a, uint b, uint c) public pure returns(uint){
        // (1, 2, 3 , ... n)
        // n = ?
        uint[] memory nth  = new uint[](_n);
        nth[0] = a;
        nth[1] = b;
        nth[2] = c;

        uint i = 3;
        while(i < _n){
            nth[i] = nth[i-1] + nth[i-2] + nth[i - 3];
            i++;
        }
        return nth[i -1];
    }
}