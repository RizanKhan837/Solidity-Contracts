// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract FundMe{

    address[] public funders; 
    mapping (address => uint256) public fundersAmount;
    uint256 minimumUsd = 10 * 1e18; // Can Send Minimum 10$
    address owner;

    constructor(){
        owner = msg.sender;
    }

    AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

    function fund() public payable{
        require(getConversionRate(msg.value) >= minimumUsd, "You Need To Spend More Gas...");
        // 1000000000000000000
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }
    function getConversionRate(uint256 price) private view returns (uint256){
        uint256 ethPrice = getPrice();
        // 1800_000000000000000000 Eth / Usd Price
        // 1000000000000000000 ETH
        uint ethPriceInUsd = (price * ethPrice) / 1e18;
        return ethPriceInUsd;
    }
    /**
     * Network: Goerli
     * Aggregator: ETH/USD
     * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
     */
    function getPrice() public view returns (uint256){
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Eth in terms Of USD
        // 2000.00000000 (The Above Func Returns Price With 8 Decimals Associated)
        // Need 10 More Decimals

        return uint256 (price * 1e10); // 1 * 10 ** 10
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