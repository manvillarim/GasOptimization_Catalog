# 12. Use Appropriate Function Visibility

This rule covers two different changes, and only one of them is invisible to a caller.

Turning a `public` function into an `external` one keeps the selector and the signature, so the contract's interface is unchanged. What it removes is the copy of the arguments into memory that a `public` function performs so that the same body can serve internal calls.

Turning a `public` function into an `internal` one removes its selector from the dispatch table. That is not a gas optimisation of a preserved interface; it is the deletion of an entry point, and it is admissible only for a function that is not part of the contract's interface, since a client calling it on the rewritten contract reaches the fallback and reverts.

## Example

### Original (Suboptimal Visibility)
```solidity
contract A {
    address public owner;
    mapping(address => uint256) private balances;

    function setBalance(address user, uint256 amount) public {
        require(msg.sender == owner, "Not authorized");
        balances[user] = amount;
    }

    function credit(address user, uint256 amount) public {
        require(msg.sender == owner, "Not authorized");
        setBalance(user, balances[user] + amount);
    }

    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }
}
```

### Optimised (Appropriate Visibility)
```solidity
contract Ao {
    address public owner;
    mapping(address => uint256) private balances;

    function setBalance(address user, uint256 amount) public {
        require(msg.sender == owner, "Not authorized");
        balances[user] = amount;
    }

    function credit(address user, uint256 amount) external {
        require(msg.sender == owner, "Not authorized");
        setBalance(user, balances[user] + amount);
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
}
```

## Applicability

`credit` and `balanceOf` become `external` because nothing inside the contract calls them; their selectors are untouched and the change cannot be observed. `setBalance` stays `public`, because `credit` calls it internally and because it is reachable from outside in the original.

Making `setBalance` internal would remove it from the interface, and the guard it carries with it. That is the change to avoid unless the function is genuinely private to the implementation, in which case the two contracts are no longer equivalent under the definition used here and the removal has to be justified as a change of interface rather than as an optimisation.

## Gas Savings

An `external` function reads its arguments from calldata instead of copying them into memory, so the saving grows with the size of the arguments and is negligible for a call taking only words. There is no runtime difference for the `internal` case, whose effect is on deployment size.
