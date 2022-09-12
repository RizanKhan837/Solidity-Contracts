pragma solidity ^0.8.12;

contract SetAndGet{
    uint private num;
    function set(uint _num) public{
        num = _num;
    }
    function get() public view returns(uint){
        return num;
    }
}