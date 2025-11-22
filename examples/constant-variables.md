# 13. Use Constant Variables for Unchanging Values

This transformation declares unchanging values as `constant` variables. Constant variables are replaced with their literal values at compile time and are not stored in contract storage, eliminating expensive storage read operations (SLOAD) when accessing these values.

## Example

### Original (Regular State Variables)
```solidity
contract RegularVariables {
    uint public maxSupply = 1000000;
    string public tokenName = "MyToken";
    address public owner = 0x1234567890123456789012345678901234567890;
    
    function checkMaxSupply() public view returns (uint) {
        return maxSupply;  // Storage read operation (SLOAD)
    }
    
    function getTokenInfo() public view returns (string memory, uint) {
        return (tokenName, maxSupply);  // Multiple storage reads
    }
}
```

### Optimised (Constant Variables)
```solidity
contract ConstantVariables {
    uint public constant MAX_SUPPLY = 1000000;
    string public constant TOKEN_NAME = "MyToken";
    address public constant OWNER = 0x1234567890123456789012345678901234567890;
    
    function checkMaxSupply() public pure returns (uint) {
        return MAX_SUPPLY;  // Direct value, no storage access
    }
    
    function getTokenInfo() public pure returns (string memory, uint) {
        return (TOKEN_NAME, MAX_SUPPLY);  // No storage reads
    }
}
```

## Gas Savings

Using `constant` eliminates storage slot allocation and replaces storage read operations with direct value access, significantly reducing both deployment and runtime gas costs.