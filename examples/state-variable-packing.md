# 7. State Variable Packing (SVP)

State Variable Packing (SVP) is a code pattern that aims to optimize the storage of state variables in smart contracts. Similar to Struct Packing (SP), SVP involves rearranging state variables to minimize the number of storage slots used in the Ethereum Virtual Machine (EVM). Since each storage slot on the EVM is 256 bits, grouping smaller data types efficiently can significantly reduce gas consumption by avoiding unused padding in storage.

## Example

### Unpacked State Variables

```solidity
contract Example {
    uint128 a;
    uint256 b;
    uint128 c;
}
```

### Packed State Variables

```solidity
contract Example {
    uint128 a;
    uint128 c;
    uint256 b;
}

```