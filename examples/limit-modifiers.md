# 21. Limit number of modifiers

This transformation reduces the use of modifiers by consolidating their logic into functions or combining multiple modifiers into single ones. Each modifier adds computational overhead and increases the function call stack depth, so minimizing their use can lead to gas savings.

## Example

### Multiple Modifiers
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
        // Function logic here
    }
}
```

### Optimized Limited Modifiers
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
    
    function validateAccess(address target) private view {
        require(authorized[msg.sender], "Not authorized");
        require(target != address(0), "Invalid address");
    }
    
    function criticalFunction(address target) public onlyOwnerNotPaused {
        validateAccess(target);
        // Function logic here
    }
}
```