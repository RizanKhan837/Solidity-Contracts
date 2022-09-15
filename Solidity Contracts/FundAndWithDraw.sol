// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;

    address[] public funders; 
    mapping (address => uint256) public fundersAmount;
    uint256 minimumUsd = 10 * 1e18; // Can Send Minimum 10$
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= minimumUsd, "You Need To Spend More Gas...");
        // 1000000000000000000
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You Are Not An Owner...");
        _;
    }

    function withdraw() public onlyOwner{
        for(uint i = 0; i< funders.length; i++){
            fundersAmount[funders[i]] = 0;
        }
        funders = new address[](0);

        // Three Ways To Send Money

        /** 1. Transfer  */
        //payable(msg.sender).transfer(address(this).balance);

        /** 2. Send  */
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Sending Failed");

        /** 3. Call (Returns 2 Variables)  => (bool callSuccess, bytes memory data)   */
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Error Sending Ethereum");
    }
}