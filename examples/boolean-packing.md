# 8 Boolean Packing

Boolean variables in Solidity are stored as `uint8` values (unsigned integer of 8 bits). However, a single bit would be enough to store each boolean. Whenever you need to group up to 32 boolean variables, you can use the **Packing Variables** pattern to optimize gas usage. If you store each boolean separately, you end up consuming more storage slots than necessary, resulting in higher gas costs.

A single `uint256` variable can hold up to 32 boolean values. By creating functions that **pack** and **unpack** boolean values into and from a single `uint256`, we can significantly reduce storage usage. The cost of these bitwise operations is lower than the cost of using multiple storage slots.

## Example

### Without Packing

```solidity
contract BooleansUnpacked {
    bool b1;
    bool b2;
    bool b3;
    // ...
    bool b32;
}
```

### With Packing

```solidity
contract BooleanPacking {
    // Instead of using 32 separate boolean variables, we use a single uint256.
    uint256 private packedBooleans;

    // Masks for packing/unpacking the booleans within the uint256.
    uint256 constant mask1 = 1 << 0;
    uint256 constant mask2 = 1 << 1;
    uint256 constant mask3 = 1 << 2;
    // ... repeat until mask32 = 1 << 31

    // Packing booleans into the uint256
    function packBooleans(bool b1, bool b2, bool b3 /*..., bool b32 */) public {
        packedBooleans = (packedBooleans & ~mask1) | (b1 ? mask1 : 0);
        packedBooleans = (packedBooleans & ~mask2) | (b2 ? mask2 : 0);
        packedBooleans = (packedBooleans & ~mask3) | (b3 ? mask3 : 0);
        // ... repeat until b32
    }

    // Unpacking booleans from the uint256
    function unpackBooleans() public view returns (bool, bool, bool /*..., bool */) {
        bool b1 = (packedBooleans & mask1) != 0;
        bool b2 = (packedBooleans & mask2) != 0;
        bool b3 = (packedBooleans & mask3) != 0;
        // ... repeat until b32
        return (b1, b2, b3 /*..., b32 */);
    }
}
```
