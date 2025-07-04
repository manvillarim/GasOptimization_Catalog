# 28. Use efficient loop increment (++ instead of +=1)

This optimization focuses on using the more efficient pre-increment operator `++` instead of the addition assignment `+=1` in loops. The pre-increment operator generates more efficient bytecode, consuming less gas per iteration.

## Example

### Inefficient Loop Increment
```solidity
contract InefficientIncrement {
   uint[] public data;
   
   function processData() public {
       for(uint i = 0; i < data.length; i += 1) { // Less efficient increment
           data[i] = data[i] * 2;
       }
   }
   
   function sumArray() public view returns(uint sum) {
       for(uint i = 0; i < data.length; i += 1) { // Less efficient increment
           sum += data[i];
       }
   }
   
   function findElement(uint target) public view returns(bool found) {
       for(uint i = 0; i < data.length; i += 1) { // Less efficient increment
           if(data[i] == target) {
               found = true;
               break;
           }
       }
   }
}
```

### Optimized Loop Increment
```solidity
contract OptimizedIncrement {
    uint[] public data;
    
    function processData() public {
        for(uint i = 0; i < data.length; i++) { // More efficient pre-increment
            data[i] = data[i] * 2;
        }
    }
    
    function sumArray() public view returns(uint sum) {
        for(uint i = 0; i < data.length; i++) { // More efficient pre-increment
            sum += data[i];
        }
    }
    
    function findElement(uint target) public view returns(bool found) {
        for(uint i = 0; i < data.length; i++) { // More efficient pre-increment
            if(data[i] == target) {
                found = true;
                break;
            }
        }
    }
}
```