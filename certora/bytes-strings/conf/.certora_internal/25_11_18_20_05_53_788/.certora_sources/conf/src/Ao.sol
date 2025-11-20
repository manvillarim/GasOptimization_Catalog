//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    bytes[] public names;
    mapping(address => bytes) public userNames;
    
    function addName(bytes memory name) external {
        names.push(name);
    }
    
    function setUserName(address user, bytes memory name) external {
        userNames[user] = name;
    }
    
    function getUserName(address user) external view returns (bytes memory) {
        return userNames[user];
    }
    
    function getNameAt(uint256 index) external view returns (bytes memory) {
        require(index < names.length, "Index out of bounds");
        return names[index];
    }
    
    function compareNames(bytes memory name1, bytes memory name2) external pure returns (bool) {
        return keccak256(name1) == keccak256(name2);
    }
}