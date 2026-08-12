// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    uint128 public quantity;
    uint128 public price;
    uint256 public total;

    function update(uint128 newQuantity, uint128 newPrice) external {
        quantity = newQuantity;
        price = newPrice;
    }

    function setTotal(uint256 newTotal) external {
        total = newTotal;
    }

    function sumNarrow() external view returns (uint256) {
        return uint256(quantity) + uint256(price);
    }
}
