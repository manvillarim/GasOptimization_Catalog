# 14. Use Immutable Variables for Constructor-Set Values

This transformation declares as `immutable` a state variable that is assigned in the constructor and never afterwards. An `immutable` occupies no storage slot: its value is written into the runtime code at construction, so every read becomes a push of a literal rather than an SLOAD.

## Example

### Original (Regular State Variables)
```solidity
contract A {
    address public owner;
    uint256 public creationTime;
    uint256 public maxSupply;

    constructor(uint256 _maxSupply) {
        owner = msg.sender;
        creationTime = block.timestamp;
        maxSupply = _maxSupply;
    }

    function getInfo() external view returns (address, uint256, uint256) {
        return (owner, creationTime, maxSupply);
    }
}
```

### Optimised (Immutable Variables)
```solidity
contract Ao {
    address public immutable owner;
    uint256 public immutable creationTime;
    uint256 public immutable maxSupply;

    constructor(uint256 _maxSupply) {
        owner = msg.sender;
        creationTime = block.timestamp;
        maxSupply = _maxSupply;
    }

    function getInfo() external view returns (address, uint256, uint256) {
        return (owner, creationTime, maxSupply);
    }
}
```

## Applicability

The names are kept. Renaming `owner` to `OWNER` to follow the convention for constants would rename its automatic getter and change the selector, which a caller of the original contract would notice.

An `immutable` may be assigned only once and only in the constructor, and it cannot be read there. A constructor that reads back a value it has just stored has to be restructured to use the local value instead, and any function that writes the variable after deployment puts the transformation out of scope.

The variables leave the storage layout, which is invisible from outside but shifts the slots of whatever was declared after them. As with `constant`, this rules out applying the transformation to an implementation behind a proxy whose storage is already in use.

## Gas Savings

Every read of the value becomes a push instead of an SLOAD, and the constructor no longer pays the storage writes. Against this, the value is embedded at each use site, so the runtime code grows with the number of reads.
