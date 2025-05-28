# 15. Use immutable variables for constructor-set values

This transformation uses immutable variables for values that are set once in the constructor and never changed afterward. Immutable variables are stored in the contract's bytecode rather than storage, making them much cheaper to access than regular state variables.

## Example

### Regular State Variables Set in Constructor
```solidity
contract RegularStateVars {
    address public owner;
    uint public creationTime;
    string public contractName;
    
    constructor(string memory _name) {
        owner = msg.sender;
        creationTime = block.timestamp;
        contractName = _name;
    }
    
    function getContractInfo() public view returns(address, uint, string memory) {
        return (owner, creationTime, contractName); // 3 storage reads
    }
}
```

### Optimized Immutable Variables

```solidity
contract ImmutableStateVars {
    address public immutable OWNER;
    uint public immutable CREATION_TIME;
    string public immutable CONTRACT_NAME;
    
    constructor(string memory _name) {
        OWNER = msg.sender;
        CREATION_TIME = block.timestamp;
        CONTRACT_NAME = _name;
    }
    
    function getContractInfo() public view returns(address, uint, string memory) {
        return (OWNER, CREATION_TIME, CONTRACT_NAME); // No storage reads
    }
}
```