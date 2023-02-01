// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

// check if a number is palindrome or not
contract Palindrome{

    function palindrome(uint num) public pure returns (string memory){
        uint rem = 0;
        uint rev;
        uint original = num;  
        while(num > 0){
            rem = num % 10;
            rev = rev * 10 + rem;
            num /= 10;
        }
        if(original == rev){
            return "palindrome";
        }
        else{
            return "not palindrome";
        }
    }
}