// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Ao {
    uint256 private packedPermissions;

    uint256 private constant CAN_MINT_MASK         = 1 << 0; // Bit 0
    uint256 private constant IS_PAUSED_MASK        = 1 << 1; // Bit 1
    uint256 private constant IS_ADMIN_MASK         = 1 << 2; // Bit 2
    uint256 private constant IS_WHITELISTED_MASK   = 1 << 3; // Bit 3
    uint256 private constant TRANSFER_ENABLED_MASK = 1 << 4; // Bit 4
    uint256 private constant IS_FROZEN_MASK        = 1 << 5; // Bit 5

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
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080000, 1037618708488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00080005, 37449) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00086005, isFrozen_) }
        uint256 newPermissions = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,newPermissions)}
        if (canMint_)         { newPermissions |= CAN_MINT_MASK; }
        if (isPaused_)        { newPermissions |= IS_PAUSED_MASK; }
        if (isAdmin_)         { newPermissions |= IS_ADMIN_MASK; }
        if (isWhitelisted_)   { newPermissions |= IS_WHITELISTED_MASK; }
        if (transferEnabled_) { newPermissions |= TRANSFER_ENABLED_MASK; }
        if (isFrozen_)        { newPermissions |= IS_FROZEN_MASK; }
        packedPermissions = newPermissions;
    }

    // --- Getters (desempacotamento) ---
    function canMint() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0004, 0) } return (packedPermissions & CAN_MINT_MASK) != 0; }
    function isPaused() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090000, 1037618708489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00090004, 0) } return (packedPermissions & IS_PAUSED_MASK) != 0; }
    function isAdmin() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070004, 0) } return (packedPermissions & IS_ADMIN_MASK) != 0; }
    function isWhitelisted() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0000, 1037618708492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000c0004, 0) } return (packedPermissions & IS_WHITELISTED_MASK) != 0; }
    function transferEnabled() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0004, 0) } return (packedPermissions & TRANSFER_ENABLED_MASK) != 0; }
    function isFrozen() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) } return (packedPermissions & IS_FROZEN_MASK) != 0; }
}