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
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 37449) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016005, isFrozen_) }
        _canMint = canMint_;
        _isPaused = isPaused_;
        _isAdmin = isAdmin_;
        _isWhitelisted = isWhitelisted_;
        _transferEnabled = transferEnabled_;
        _isFrozen = isFrozen_;
    }

    // --- Getters ---
    function canMint() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) } return _canMint; }
    function isPaused() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020004, 0) } return _isPaused; }
    function isAdmin() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) } return _isAdmin; }
    function isWhitelisted() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050004, 0) } return _isWhitelisted; }
    function transferEnabled() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) } return _transferEnabled; }
    function isFrozen() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) } return _isFrozen; }
}