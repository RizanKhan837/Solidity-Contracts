// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Bank{

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

    function withdraw() public{
        require(balances[msg.sender] > 0,"You have not deposited any ether");
        uint currentTime = block.timestamp;
        uint difference = currentTime - timestamp[msg.sender];

        // checking the time difference 
        if (difference > 5 && difference <= 6 ) {
            payable(msg.sender).transfer((balances[msg.sender] + (msg.sender.balance * 10) / 100));
        }
        else if(difference > 10 && difference <= 12) {
            payable(msg.sender).transfer((balances[msg.sender] + (msg.sender.balance * 10) / 100));
        }
        else if(difference > 15 ) {
            payable(msg.sender).transfer((balances[msg.sender] + (msg.sender.balance * 10) / 100));
        }
        else{
            payable(msg.sender).transfer((balances[msg.sender]));
        }
        balances[msg.sender] = 0;
    }
}