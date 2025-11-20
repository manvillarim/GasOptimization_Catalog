// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    string public name;
    
    function setName(string memory _name) external {
        name = _name;
    }
    
    function getName() external view returns (string memory) {
        return name;
    }
    
    function compareName(string memory _name) external view returns (bool) {
        return keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(_name));
    }
    
    function getNameHash() external view returns (bytes32) {
        return keccak256(abi.encodePacked(name));
    }
}