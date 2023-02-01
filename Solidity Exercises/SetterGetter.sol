pragma solidity ^0.8.12;


// create a contract that has a private variable and a function to set the value of the variable and a function to get the value of the variable
contract SetAndGet{
    uint private num;
    function set(uint _num) public{
        num = _num;
    }
    function get() public view returns(uint){
        return num;
    }
}