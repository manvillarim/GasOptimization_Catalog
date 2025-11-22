# 29. Use Bytes Instead of Strings

This transformation replaces `string` types with `bytes` types when UTF-8 encoding is not required. Strings in Solidity are UTF-8 encoded and include additional overhead for character handling, while bytes provide raw byte storage without encoding overhead. For data that doesn't require string manipulation or UTF-8 support, bytes are more gas-efficient.

## Example

### Original (Using String)
```solidity
contract StringStorage {
    string public data;
    
    function setData(string memory _data) public {
        data = _data;
    }
    
    function getData() public view returns (string memory) {
        return data;
    }
    
    function getLength() public view returns (uint) {
        return bytes(data).length;  // Conversion required
    }
}
```

### Optimised (Using Bytes)
```solidity
contract BytesStorage {
    bytes public data;
    
    function setData(bytes memory _data) public {
        data = _data;
    }
    
    function getData() public view returns (bytes memory) {
        return data;
    }
    
    function getLength() public view returns (uint) {
        return data.length;  // Direct access
    }
}
```

## Gas Savings

Using `bytes` instead of `string` eliminates UTF-8 encoding overhead and provides more efficient storage and manipulation operations when string-specific features are not needed.