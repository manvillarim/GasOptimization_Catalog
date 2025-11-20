//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    bytes32[] public names;
    mapping(address => bytes32) public userNames;
    
    function addName(bytes32 name) external {
        names.push(name);
    }
    
    function setUserName(address user, bytes32 name) external {
        userNames[user] = name;
    }
    
    function getUserName(address user) external view returns (bytes32) {
        return userNames[user];
    }
    
    function getNameAt(uint256 index) external view returns (bytes32) {
        require(index < names.length, "Index out of bounds");
        return names[index];
    }
    
    function compareNames(bytes32 name1, bytes32 name2) external pure returns (bool) {
        return name1 == name2;
    }
}