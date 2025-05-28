# 14. Use constant variables for unchanging values

This transformation declares unchanging values as constant variables. Constant variables are replaced with their values at compile time, eliminating the need for storage operations and significantly reducing gas costs for reading these values.

## Example

### Regular State Variables
```solidity
contract RegularVariables {
    uint public maxSupply = 1000000;
    string public tokenName = "MyToken";
    address public contractOwner = 0x1234567890123456789012345678901234567890;
    
    function checkMaxSupply() public view returns(uint) {
        return maxSupply; // Storage read operation
    }
    
    function getTokenInfo() public view returns(string memory, uint) {
        return (tokenName, maxSupply); // Multiple storage reads
    }
}
```

### Optimized Constant Variables
```solidity
contract ConstantVariables {
    uint public constant MAX_SUPPLY = 1000000;
    string public constant TOKEN_NAME = "MyToken";
    address public constant CONTRACT_OWNER = 0x1234567890123456789012345678901234567890;
    
    function checkMaxSupply() public pure returns(uint) {
        return MAX_SUPPLY; // No storage read, direct value
    }
    
    function getTokenInfo() public pure returns(string memory, uint) {
        return (TOKEN_NAME, MAX_SUPPLY); // No storage reads
    }
}
```