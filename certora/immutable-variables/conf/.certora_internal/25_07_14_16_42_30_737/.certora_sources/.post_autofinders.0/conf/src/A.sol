// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract A - Regular State Variables
 * @notice This contract uses regular state variables that are stored in contract storage
 * @dev All constant values are stored in storage slots, requiring expensive SLOAD operations
 */
contract A {
    // Regular state variables - stored in contract storage
    uint public totalSupply;        // Storage slot 0
    mapping(address => uint) public balances; // Storage slot 1
    string public tokenName;        // Storage slot 2
    string public tokenSymbol;      // Storage slot 3
    address public owner;           // Storage slot 4
    uint public deploymentBlock;    // Storage slot 5
    uint public maxSupply;          // Storage slot 6
    uint8 public decimals;          // Storage slot 7
    bytes32 public merkleRoot;      // Storage slot 8
    
    /**
     * @notice Constructor sets all configuration values in storage
     * @param _name Token name
     * @param _symbol Token symbol
     * @param _decimals Number of decimals
     * @param _maxSupply Maximum token supply
     * @param _merkleRoot Merkle root for whitelist verification
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _maxSupply,
        bytes32 _merkleRoot
    ) {
        totalSupply = 0;                 // SSTORE - expensive
        tokenName = _name;               // SSTORE - expensive
        tokenSymbol = _symbol;           // SSTORE - expensive
        owner = msg.sender;              // SSTORE - expensive
        deploymentBlock = block.number;  // SSTORE - expensive
        maxSupply = _maxSupply;          // SSTORE - expensive
        decimals = _decimals;            // SSTORE - expensive
        merkleRoot = _merkleRoot;        // SSTORE - expensive
    }
    
    /**
     * @notice Returns token configuration information
     * @return All token configuration values
     * @dev Performs 7 storage reads - each costs 2100 gas
     */
    function getTokenInfo() public view returns(
        address,
        uint,
        uint,
        string memory,
        string memory,
        uint8,
        bytes32
    ) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        return (
            owner,          // SLOAD - 2100 gas
            deploymentBlock, // SLOAD - 2100 gas
            maxSupply,      // SLOAD - 2100 gas
            tokenName,      // SLOAD - 2100 gas + string overhead
            tokenSymbol,    // SLOAD - 2100 gas + string overhead
            decimals,       // SLOAD - 2100 gas
            merkleRoot      // SLOAD - 2100 gas
        );
        // Total: ~14,700 gas + string overhead
    }
    
    /**
     * @notice Mints new tokens
     * @param to Recipient address
     * @param amount Amount to mint
     * @dev Requires storage reads for owner and maxSupply validation
     */
    function mint(address to, uint amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026001, amount) }
        require(msg.sender == owner, "Only owner");        // SLOAD - 2100 gas
        require(totalSupply + amount <= maxSupply, "Exceeds max supply"); // SLOAD - 2100 gas
        
        totalSupply += amount;    // SLOAD + SSTORE
        balances[to] += amount;   // SLOAD + SSTORE
    }
    
    /**
     * @notice Validates merkle proof for whitelist
     * @param proof Merkle proof array
     * @param leaf Leaf node to verify
     * @return bool True if proof is valid
     * @dev Requires storage read for merkleRoot comparison
     */
    function validateMerkleProof(bytes32[] calldata proof, bytes32 leaf) public view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016002, leaf) }
        bytes32 computedHash = leaf;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,computedHash)}
        
        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,proofElement)}
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,computedHash)}
            }
        }
        
        return computedHash == merkleRoot; // SLOAD - 2100 gas
    }
    
    /**
     * @notice Calculates transaction fees based on deployment age
     * @param amount Transaction amount
     * @return uint Fee amount
     * @dev Requires multiple storage reads for calculations
     */
    function calculateFees(uint amount) public view returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046000, amount) }
        // Multiple storage reads for fee calculation
        if (block.number - deploymentBlock < 1000) {  // SLOAD - 2100 gas
            return amount * decimals / 10000;         // SLOAD - 2100 gas
        }
        return amount * decimals / 1000;              // SLOAD - 2100 gas
    }
    
    /**
     * @notice Checks if caller is contract owner
     * @return bool True if caller is owner
     * @dev Simple storage read operation
     */
    function isOwner() public view returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        return msg.sender == owner; // SLOAD - 2100 gas
    }
}