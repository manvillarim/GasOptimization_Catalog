// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    string[] public names;
    mapping(address => string) public userNames;
    
    function addName(string memory name) external {
        names.push(name);
    }
    
    function setUserName(address user, string memory name) external {
        userNames[user] = name;
    }
    
    function getUserName(address user) external view returns (string memory) {
        return userNames[user];
    }
    
    function getNameAt(uint256 index) external view returns (string memory) {
        require(index < names.length, "Index out of bounds");
        return names[index];
    }
    
    function compareNames(string memory name1, string memory name2) external pure returns (bool) {
        return keccak256(abi.encodePacked(name1)) == keccak256(abi.encodePacked(name2));
    }
    
    // Funções auxiliares para verificação formal
    function getNameHashAt(uint256 index) external view returns (bytes32) {
        require(index < names.length, "Index out of bounds");
        return keccak256(abi.encodePacked(names[index]));
    }
    
    function getUserNameHash(address user) external view returns (bytes32) {
        return keccak256(abi.encodePacked(userNames[user]));
    }
    
    function getNamesLength() external view returns (uint256) {
        return names.length;
    }
}