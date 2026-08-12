# 11. Delete Unused Storage Variables

This transformation clears a storage location that the contract will no longer read, so that the write qualifies for the refund the EVM grants for returning a non-zero slot to zero.

Two things this rule is often taken to mean are worth separating, because only one of them saves gas.

Replacing `x = 0` by `delete x` saves nothing. For a value type, `delete` is defined as the assignment of the zero value, and the two forms compile to the same code: on solc 0.8.26 with the optimiser at 200 runs, the pair of contracts differing only in this respect produces byte-identical runtime *and* creation code. The choice between them is a matter of intent, not of cost.

What does save gas is clearing a slot that would otherwise be left set. Since EIP-3529 a clearing write refunds 4,800 gas, and the refunds of a transaction are capped at one fifth of the gas it consumes.

## Example

### Original (Slot Left Set)
```solidity
contract A {
    mapping(address => uint256) private balances;
    mapping(address => bool) private isRegistered;

    function register() external {
        require(!isRegistered[msg.sender], "Already registered");
        isRegistered[msg.sender] = true;
        balances[msg.sender] = 1000;
    }

    function removeUser(address user) external {
        require(isRegistered[user], "Not registered");
        isRegistered[user] = false;
    }

    function balanceOf(address user) external view returns (uint256) {
        return isRegistered[user] ? balances[user] : 0;
    }
}
```

### Optimised (Slot Cleared)
```solidity
contract Ao {
    mapping(address => uint256) private balances;
    mapping(address => bool) private isRegistered;

    function register() external {
        require(!isRegistered[msg.sender], "Already registered");
        isRegistered[msg.sender] = true;
        balances[msg.sender] = 1000;
    }

    function removeUser(address user) external {
        require(isRegistered[user], "Not registered");
        isRegistered[user] = false;
        delete balances[user];
    }

    function balanceOf(address user) external view returns (uint256) {
        return isRegistered[user] ? balances[user] : 0;
    }
}
```

## Applicability

The cleared location must be unreachable from outside. Here `balances` is private and the only path to it is `balanceOf`, which returns zero for a user that is not registered, so the two contracts answer the same on every query even though their storage differs. Declaring the mapping `public` would break this at once: the automatic getter would return 1000 in `A` and 0 in `Ao` for a removed user.

This is the one rule of the catalogue whose coupling invariant is not plain state equality. The two contracts are not related slot by slot after a removal; they are related by the equality of `isRegistered` together with the equality of `balances` restricted to the registered addresses. The obligation to check is that no function can observe the difference outside that restriction.

## Gas Savings

Each cleared slot refunds 4,800 gas at the end of the transaction, subject to the cap of one fifth of the gas consumed. The clearing write itself is paid for at the normal rate, so the rule pays off when the transaction is large enough for the refund not to be capped away.
