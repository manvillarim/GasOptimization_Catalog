// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
   address public owner;
   bool public paused;
   mapping(address => bool) public authorized;
   
   // Campos adicionais para o CVL
   uint public total;
   uint public count;
   uint[] public numbers; // Usado para simular dados que seriam manipulados
   
   constructor() {
       owner = msg.sender;
       paused = false;
       total = 0;
       count = 0;
   }
   
   modifier onlyOwner() {
       require(msg.sender == owner, "Not owner");
       _;
   }
   
   function authorize(address addr) public onlyOwner {
       authorized[addr] = true;
   }
   
   function unauthorize(address addr) public onlyOwner {
       authorized[addr] = false;
   }
   
   function setPaused(bool _paused) public onlyOwner {
       paused = _paused;
   }
   
   function criticalFunction(address target) public {
       require(msg.sender == owner, "Not owner");
       require(!paused, "Contract paused");
       require(authorized[msg.sender], "Not authorized");
       require(target != address(0), "Invalid address");
       
       // Lógica da função crítica
       if (target != address(0)) {
           numbers.push(10);
           total += 10;
           count++;
       }
   }
   
   // Métodos para o CVL
   function processNumbers(uint _num) public {
       numbers.push(_num);
       total += _num;
       count++;
   }
   
   function calculateAverage() public view returns (uint) {
       if (count == 0) {
           return 0;
       }
       return total / count;
   }
   
   function getTotal() public view returns (uint) {
       return total;
   }
   
   function getCount() public view returns (uint) {
       return count;
   }
   
   function getNumbersLength() public view returns (uint) {
       return numbers.length;
   }
   
   function getAuthorized(address addr) external view returns(bool) {
       return authorized[addr];
   }
}