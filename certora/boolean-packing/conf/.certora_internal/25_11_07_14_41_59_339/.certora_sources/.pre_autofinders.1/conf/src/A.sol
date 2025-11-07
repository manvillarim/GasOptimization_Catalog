// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    bool private _canMint;
    bool private _isPaused;
    bool private _isAdmin;
    bool private _isWhitelisted;
    bool private _transferEnabled;
    bool private _isFrozen;

    constructor(
        bool canMint_,
        bool isPaused_,
        bool isAdmin_,
        bool isWhitelisted_,
        bool transferEnabled_,
        bool isFrozen_
    ) {
        setPermissions(canMint_, isPaused_, isAdmin_, isWhitelisted_, transferEnabled_, isFrozen_);
    }

    function setPermissions(
        bool canMint_,
        bool isPaused_,
        bool isAdmin_,
        bool isWhitelisted_,
        bool transferEnabled_,
        bool isFrozen_
    ) public {
        _canMint = canMint_;
        _isPaused = isPaused_;
        _isAdmin = isAdmin_;
        _isWhitelisted = isWhitelisted_;
        _transferEnabled = transferEnabled_;
        _isFrozen = isFrozen_;
    }

    // --- Getters ---
    function canMint() public view returns (bool) { return _canMint; }
    function isPaused() public view returns (bool) { return _isPaused; }
    function isAdmin() public view returns (bool) { return _isAdmin; }
    function isWhitelisted() public view returns (bool) { return _isWhitelisted; }
    function transferEnabled() public view returns (bool) { return _transferEnabled; }
    function isFrozen() public view returns (bool) { return _isFrozen; }
}