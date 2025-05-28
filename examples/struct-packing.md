# 5. Struct Packing

This transformation focuses on how variables are laid out in storage. In Solidity, each storage slot is 32 bytes, and variables within a `struct` can be packed together if their combined size is ≤ 32 bytes. By arranging smaller-sized variables (like `uint8`, `uint16`, or `bool`) next to each other in an optimal order inside structs, you reduce the number of storage slots used. Since storage access is expensive in terms of gas, this optimization can yield significant savings.

## Example

### Unpacked Struct

```solidity
struct Data {
    uint256 a;
    bool b;
    uint8 c;
}
```

### Packed Struct

```solidity
struct Data {
    uint8 c;
    bool b;
    uint256 a;
}
```
