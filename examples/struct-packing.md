# 5. Struct Packing

This transformation reorders the members of a struct so that those narrower than a word share a slot. The rule for members is the one that governs state variables: slots are assigned in declaration order, and a member that does not fit in what remains of the current slot starts a new one. A wide member placed between two narrow ones wastes the space beside each of them.

## Example

### Original (Unpacked Struct)
```solidity
contract A {
    struct Order {
        uint128 quantity;   // slot 0, bytes 0-15
        uint256 amount;     // slot 1
        uint128 price;      // slot 2, bytes 0-15
    }

    mapping(uint256 => Order) private orders;

    function store(uint256 id, uint128 quantity, uint256 amount, uint128 price) external {
        orders[id] = Order(quantity, amount, price);
    }

    function get(uint256 id) external view returns (uint128, uint256, uint128) {
        Order storage o = orders[id];
        return (o.quantity, o.amount, o.price);
    }
}
```

### Optimised (Packed Struct)
```solidity
contract Ao {
    struct Order {
        uint128 quantity;   // slot 0, bytes 0-15
        uint128 price;      // slot 0, bytes 16-31
        uint256 amount;     // slot 1
    }

    mapping(uint256 => Order) private orders;

    function store(uint256 id, uint128 quantity, uint256 amount, uint128 price) external {
        orders[id] = Order(quantity, price, amount);
    }

    function get(uint256 id) external view returns (uint128, uint256, uint128) {
        Order storage o = orders[id];
        return (o.quantity, o.amount, o.price);
    }
}
```

The two layouts are 96 and 64 bytes per record, as reported by `solc --storage-layout`.

## Applicability

Only members that leave room beside them are worth moving. Members that already pack gain nothing from being reordered: a struct declared `uint256 amount; bool active; uint8 level;` occupies two slots, because the `bool` and the `uint8` are one byte each and share the second slot, and reordering it to put them first leaves it at two slots. The saving appears only where a wide member separates narrow ones whose widths sum to at most a word.

The order of the members is part of the struct's ABI wherever it crosses the contract boundary. Reordering changes the positional constructor `Order(...)`, which is why the call in `store` differs on the two sides, and it would change the tuple returned by an automatic getter if the struct were held in a `public` variable. The example keeps the mapping private and returns the members in a fixed order, so the interface is the same on both sides.

As with state variables, the two layouts are related member by member rather than slot by slot, and the rule cannot be applied to a struct whose storage is already deployed behind a proxy.

## Gas Savings

Each record occupies two slots instead of three, so storing one pays two writes instead of three, and a function reading `quantity` and `price` together reaches them with a single SLOAD. Where the narrow members are written independently, the shared slot is instead read-modified-written, and the saving shrinks.
