# 20. Limit Number of Modifiers

This transformation reduces the number of modifiers by consolidating their logic into fewer modifiers or helper functions. Each modifier adds overhead to function calls by expanding the bytecode and increasing the call depth. Combining related checks or using internal validation functions can reduce this overhead while maintaining code security.

## Example

### Original (Multiple Modifiers)
```solidity
contract MultipleModifiers {
    address public owner;
    bool public paused;
    mapping(address => bool) public authorized;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    modifier notPaused() {
        require(!paused, "Contract paused");
        _;
    }
    
    modifier onlyAuthorized() {
        require(authorized[msg.sender], "Not authorized");
        _;
    }
    
    modifier validAddress(address addr) {
        require(addr != address(0), "Invalid address");
        _;
    }
    
    function criticalFunction(address target) 
        public 
        onlyOwner 
        notPaused 
        onlyAuthorized 
        validAddress(target) 
    {
        // Function logic
    }
}
```

### Optimised (Consolidated Modifiers)
```solidity
contract LimitedModifiers {
    address public owner;
    bool public paused;
    mapping(address => bool) public authorized;
    
    modifier onlyOwnerNotPaused() {
        require(msg.sender == owner, "Not owner");
        require(!paused, "Contract paused");
        _;
    }
    
    function validateAccess(address target) internal view {
        require(authorized[msg.sender], "Not authorized");
        require(target != address(0), "Invalid address");
    }
    
    function criticalFunction(address target) public onlyOwnerNotPaused {
        validateAccess(target);
        // Function logic
    }
}
```

## Gas Savings

Consolidating modifiers reduces bytecode size and function call overhead by minimizing the depth of modifier expansion, while internal validation functions provide similar security guarantees with less bytecode duplication.