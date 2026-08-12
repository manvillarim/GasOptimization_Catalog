// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    uint128 public quantity;
    uint256 public total;
    uint128 public price;

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
