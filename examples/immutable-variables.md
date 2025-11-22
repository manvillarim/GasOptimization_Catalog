# 14. Use Immutable Variables for Constructor-Set Values

This transformation uses `immutable` variables for values that are set once in the constructor and never changed afterward. Immutable variables are stored directly in the contract's bytecode rather than in storage slots, eliminating expensive storage read operations (SLOAD) and making access significantly cheaper.

## Example

### Original (Regular State Variables)
```solidity
contract RegularStateVars {
    address public owner;
    uint public creationTime;
    uint public maxSupply;
    
    constructor(uint _maxSupply) {
        owner = msg.sender;
        creationTime = block.timestamp;
        maxSupply = _maxSupply;
    }
    
    function getInfo() public view returns (address, uint, uint) {
        return (owner, creationTime, maxSupply);  // 3 storage reads (SLOAD)
    }
}
```

### Optimised (Immutable Variables)
```solidity
contract ImmutableStateVars {
    address public immutable OWNER;
    uint public immutable CREATION_TIME;
    uint public immutable MAX_SUPPLY;
    
    constructor(uint _maxSupply) {
        OWNER = msg.sender;
        CREATION_TIME = block.timestamp;
        MAX_SUPPLY = _maxSupply;
    }
    
    function getInfo() public view returns (address, uint, uint) {
        return (OWNER, CREATION_TIME, MAX_SUPPLY);  // Direct bytecode access
    }
}
```

## Gas Savings

Using `immutable` eliminates storage slot allocation and replaces expensive storage read operations with direct bytecode access, significantly reducing runtime gas costs for variables set once in the constructor.