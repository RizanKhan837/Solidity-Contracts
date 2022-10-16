// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TimeLock{

    mapping (address => uint) balances;
    address[] public arr;
    uint counter;
    mapping (address => uint256) timestamp;

    function deposit(address add) public payable {
        balances[add] += msg.value;
        arr.push(add);
        timestamp[msg.sender] = block.timestamp;
    }

    function getBalance(address add) public view returns (uint256) {
        return balances[add];
    }

    function withdraw() public payable{
        require(balances[msg.sender] > 0,"You have not deposited any ether");
        uint currentTime = block.timestamp;
        uint difference = currentTime - timestamp[msg.sender];

        require(difference > 60 , "Can't Withdraw...");
        payable(msg.sender).transfer((balances[msg.sender] + (msg.sender.balance * 10) / 100));
        balances[msg.sender] = 0;
    }
}