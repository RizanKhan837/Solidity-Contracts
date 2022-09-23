// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./PriceConvertor.sol";

error Not_Owner();

contract FundMe{

    using PriceConverter for uint256;

    address[] public funders; 
    mapping (address => uint256) public fundersAmount;
    uint256 public constant MINIMUM_USD = 10 * 1e18; // Can Send Minimum 10$
    // 21,415 Gas - constant => 21,415 * 11000000000 = $0.32
    // 23,515 Gas - non-constant => 23,515 * 11000000000 = $0.35

    address immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        // Here msg.value will pass as the first parameter in getConversionRate 
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You Need To Spend More Gas...");
        // 1000000000000000000
        checkDuplicate(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "You Are Not An Owner...");
        if(msg.sender != i_owner){ revert Not_Owner(); }  // Gas Efficient
        _;
    }
    function checkDuplicate(address arr) public {
        for (uint i = 0; i< funders.length; i++){
            if (funders[i] != arr){
                funders.push(arr);
            }
        }
    }

    function withdraw() public onlyOwner{
        for(uint i = 0; i< funders.length; i++){
            fundersAmount[funders[i]] = 0;
        }
        funders = new address[](0);

        // Three Ways To Send Money

        /** 1. Transfer  */
        // payable(msg.sender).transfer(address(this).balance);

        /** 2. Send  */
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Sending Failed");

        /** 3. Call  */
        // (Returns 2 Variables)  => (bool callSuccess, bytes memory data) 
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Error Sending Ethereum");
    }

    receive() external payable {  // Used When Someone Send Transaction Without CallData 
        fund();
    }

    fallback() external  payable {  // Used When There Is No receive() function and msg.data is not empty
        fund();
    }

}