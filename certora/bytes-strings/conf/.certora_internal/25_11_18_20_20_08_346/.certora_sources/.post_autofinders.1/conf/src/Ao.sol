// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    bytes public name;
    
    function setName(bytes memory _name) external {
        name = _name;
    }
    
    function getName() external view returns (bytes memory) {
        return name;
    }
    
    function compareName(bytes memory _name) external view returns (bool) {
        return keccak256(name) == keccak256(_name);
    }
    
    function getNameHash() external view returns (bytes32) {
        return keccak256(name);
    }
}