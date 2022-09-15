// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getConversionRate(uint256 price) internal view returns (uint256){
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
    function getPrice() internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // Eth in terms Of USD
        // 2000.00000000 (The Above Func Returns Price With 8 Decimals Associated)
        // Need 10 More Decimals

        return uint256 (price * 1e10); // 1 * 10 ** 10
    }

}