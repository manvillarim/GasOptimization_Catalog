// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    struct Order {
        uint128 quantity;
        uint256 amount;
        uint128 price;
    }

    mapping(uint256 => Order) private orders;
    uint256 public orderCount;

    function createOrder(uint128 quantity, uint256 amount, uint128 price) external returns (uint256) {
        uint256 id = orderCount;
        orders[id] = Order(quantity, amount, price);
        orderCount++;
        return id;
    }

    function updateAmount(uint256 id, uint256 amount) external {
        orders[id].amount = amount;
    }

    function updateNarrow(uint256 id, uint128 quantity, uint128 price) external {
        orders[id].quantity = quantity;
        orders[id].price = price;
    }

    function getOrder(uint256 id) external view returns (uint128, uint256, uint128) {
        Order storage o = orders[id];
        return (o.quantity, o.amount, o.price);
    }
}
