# 1. Replace require with custom errors

In Solidity, the `require` statement is commonly used for input validation and access control. While it's readable and convenient, it also embeds a **revert reason string** into the contract's bytecode. This string must be stored in memory when the condition fails and returned as part of the revert data — leading to **higher gas consumption**, especially when strings are long.

## What Makes Custom Errors More Efficient?

Starting with Solidity **v0.8.4**, the language introduced **custom errors**, a feature that allows developers to define named error types with optional arguments. These errors are encoded using a 4-byte selector and any provided parameters, making them **much cheaper** than dynamic revert strings.

### Example Comparison

```solidity
// Traditional require with a string
require(amount > 0, "Amount must be greater than 0");

// Custom error usage
if (amount == 0) {
    revert InvalidAmount();
}
