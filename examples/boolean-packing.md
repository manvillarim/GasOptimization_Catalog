# 7. Boolean Packing

This transformation replaces a group of `bool` state variables by a single `uint256` whose bits carry the flags, read and written through masks.

Solidity already packs consecutive booleans: a `bool` occupies one byte, so up to 32 of them share a storage slot. For a group of that size the rule does not reduce the number of slots. What it removes is the read-modify-write that each separate assignment performs on the shared word: writing six booleans one at a time issues six masked writes to the same slot, whereas the packed version composes the word in a local variable and writes it once. Beyond 32 flags the unpacked layout needs a further slot for every additional 32, and the rule then saves storage as well.

## Example

### Original (Separate Booleans)
```solidity
contract A {
    bool private _canMint;
    bool private _isPaused;
    bool private _isAdmin;
    bool private _isWhitelisted;
    bool private _transferEnabled;
    bool private _isFrozen;

    function setPermissions(
        bool canMint_, bool isPaused_, bool isAdmin_,
        bool isWhitelisted_, bool transferEnabled_, bool isFrozen_
    ) public {
        _canMint = canMint_;
        _isPaused = isPaused_;
        _isAdmin = isAdmin_;
        _isWhitelisted = isWhitelisted_;
        _transferEnabled = transferEnabled_;
        _isFrozen = isFrozen_;
    }

    function canMint() public view returns (bool) { return _canMint; }
    function isPaused() public view returns (bool) { return _isPaused; }
    function isAdmin() public view returns (bool) { return _isAdmin; }
    function isWhitelisted() public view returns (bool) { return _isWhitelisted; }
    function transferEnabled() public view returns (bool) { return _transferEnabled; }
    function isFrozen() public view returns (bool) { return _isFrozen; }
}
```

### Optimised (Packed Booleans)
```solidity
contract Ao {
    uint256 private _flags;

    uint256 private constant CAN_MINT         = 1 << 0;
    uint256 private constant IS_PAUSED        = 1 << 1;
    uint256 private constant IS_ADMIN         = 1 << 2;
    uint256 private constant IS_WHITELISTED   = 1 << 3;
    uint256 private constant TRANSFER_ENABLED = 1 << 4;
    uint256 private constant IS_FROZEN        = 1 << 5;

    function setPermissions(
        bool canMint_, bool isPaused_, bool isAdmin_,
        bool isWhitelisted_, bool transferEnabled_, bool isFrozen_
    ) public {
        uint256 newFlags;
        if (canMint_)         { newFlags |= CAN_MINT; }
        if (isPaused_)        { newFlags |= IS_PAUSED; }
        if (isAdmin_)         { newFlags |= IS_ADMIN; }
        if (isWhitelisted_)   { newFlags |= IS_WHITELISTED; }
        if (transferEnabled_) { newFlags |= TRANSFER_ENABLED; }
        if (isFrozen_)        { newFlags |= IS_FROZEN; }
        _flags = newFlags;
    }

    function canMint() public view returns (bool) { return (_flags & CAN_MINT) != 0; }
    function isPaused() public view returns (bool) { return (_flags & IS_PAUSED) != 0; }
    function isAdmin() public view returns (bool) { return (_flags & IS_ADMIN) != 0; }
    function isWhitelisted() public view returns (bool) { return (_flags & IS_WHITELISTED) != 0; }
    function transferEnabled() public view returns (bool) { return (_flags & TRANSFER_ENABLED) != 0; }
    function isFrozen() public view returns (bool) { return (_flags & IS_FROZEN) != 0; }
}
```

The flags are private and reached only through the getters, so the two contracts expose the same interface and the coupling invariant relates the six booleans of `A` to the corresponding bits of `_flags` in `Ao`.

## Gas Savings

Measured with Foundry on the pair above (solc 0.8.26, optimiser at 200 runs), `setPermissions` costs 33,218 gas in `A` against 33,064 in `Ao`, and reading the six getters costs 44,635 against 44,198. The saving stays under 1% because the six booleans already occupy a single slot; it is the masking, not the slot count, that the rule is removing at this size.
