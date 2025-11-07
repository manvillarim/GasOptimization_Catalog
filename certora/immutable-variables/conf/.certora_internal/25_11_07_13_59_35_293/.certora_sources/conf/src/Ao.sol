// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract Ao - Immutable Variables Optimization
 * @notice This contract uses immutable variables for values set once in constructor
 * @dev Immutable variables are stored in bytecode, not storage, making access much cheaper
 */
contract Ao {
    // Immutable variables - stored in contract bytecode (value types only)
    address public immutable OWNER;           // No storage slot - embedded in bytecode
    uint public immutable DEPLOYMENT_BLOCK;  // No storage slot - embedded in bytecode
    uint public immutable MAX_SUPPLY;        // No storage slot - embedded in bytecode
    uint8 public immutable DECIMALS;         // No storage slot - embedded in bytecode
    bytes32 public immutable MERKLE_ROOT;    // No storage slot - embedded in bytecode
    
    // String variables must remain as state variables (reference types not allowed as immutable)
    string public tokenName;                 // Storage slot 2
    string public tokenSymbol;               // Storage slot 3
    
    // Mutable state variables - still require storage
    uint public totalSupply;                 // Storage slot 0
    mapping(address => uint) public balances; // Storage slot 1
    
    /**
     * @notice Constructor sets immutable values and string state variables
     * @param _name Token name
     * @param _symbol Token symbol
     * @param _decimals Number of decimals
     * @param _maxSupply Maximum token supply
     * @param _merkleRoot Merkle root for whitelist verification
     * @dev Immutable assignments are embedded in bytecode, strings stored in storage
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _maxSupply,
        bytes32 _merkleRoot
    ) {
        OWNER = msg.sender;              // Embedded in bytecode - no storage cost
        DEPLOYMENT_BLOCK = block.number; // Embedded in bytecode - no storage cost
        MAX_SUPPLY = _maxSupply;         // Embedded in bytecode - no storage cost
        DECIMALS = _decimals;            // Embedded in bytecode - no storage cost
        MERKLE_ROOT = _merkleRoot;       // Embedded in bytecode - no storage cost
        
        // String variables must be stored in storage (cannot be immutable)
        tokenName = _name;               // SSTORE - required for reference types
        tokenSymbol = _symbol;           // SSTORE - required for reference types
        totalSupply = 0;                 // SSTORE - mutable variable
    }
    
    /**
     * @notice Returns token configuration information
     * @return All token configuration values
     * @dev Most values from bytecode, strings still require storage reads
     */
    function getTokenInfo() public view returns(
        address,
        uint,
        uint,
        string memory,
        string memory,
        uint8,
        bytes32
    ) {
        return (
            OWNER,           // Bytecode read - ~3 gas
            DEPLOYMENT_BLOCK, // Bytecode read - ~3 gas
            MAX_SUPPLY,      // Bytecode read - ~3 gas
            tokenName,       // SLOAD - 2100 gas (cannot be immutable)
            tokenSymbol,     // SLOAD - 2100 gas (cannot be immutable)
            DECIMALS,        // Bytecode read - ~3 gas
            MERKLE_ROOT      // Bytecode read - ~3 gas
        );
        // Total: ~4,200 gas (vs ~14,700 gas in contract A)
    }
    
    /**
     * @notice Mints new tokens
     * @param to Recipient address
     * @param amount Amount to mint
     * @dev Uses immutable variables for validation - much cheaper than storage reads
     */
    function mint(address to, uint amount) public {
        require(msg.sender == OWNER, "Only owner");        // Bytecode read - ~3 gas
        require(totalSupply + amount <= MAX_SUPPLY, "Exceeds max supply"); // Bytecode read - ~3 gas
        
        totalSupply += amount;    // SLOAD + SSTORE
        balances[to] += amount;   // SLOAD + SSTORE
    }
    
    /**
     * @notice Validates merkle proof for whitelist
     * @param proof Merkle proof array
     * @param leaf Leaf node to verify
     * @return bool True if proof is valid
     * @dev Uses immutable MERKLE_ROOT - no storage read required
     */
    function validateMerkleProof(bytes32[] calldata proof, bytes32 leaf) public view returns(bool) {
        bytes32 computedHash = leaf;
        
        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        
        return computedHash == MERKLE_ROOT; // Bytecode read - ~3 gas (vs 2100 gas)
    }
    
    /**
     * @notice Calculates transaction fees based on deployment age
     * @param amount Transaction amount
     * @return uint Fee amount
     * @dev Uses immutable variables - no storage reads required
     */
    function calculateFees(uint amount) public view returns(uint) {
        // All reads from bytecode - extremely cheap
        if (block.number - DEPLOYMENT_BLOCK < 1000) {  // Bytecode read - ~3 gas
            return amount * DECIMALS / 10000;          // Bytecode read - ~3 gas
        }
        return amount * DECIMALS / 1000;               // Bytecode read - ~3 gas
    }
    
    /**
     * @notice Checks if caller is contract owner
     * @return bool True if caller is owner
     * @dev Uses immutable OWNER - no storage read required
     */
    function isOwner() public view returns(bool) {
        return msg.sender == OWNER; // Bytecode read - ~3 gas (vs 2100 gas)
    }
}