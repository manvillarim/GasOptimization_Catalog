using A as a;
using Ao as ao;

methods {
    // Contract A methods (unpacked booleans)
    function a.getBooleans() external returns (bool, bool, bool, bool, bool, bool, bool, bool,
                                               bool, bool, bool, bool, bool, bool, bool, bool,
                                               bool, bool, bool, bool, bool, bool, bool, bool,
                                               bool, bool, bool, bool, bool, bool, bool, bool) envfree;
    function a.setBooleans(bool, bool, bool, bool, bool, bool, bool, bool,
                          bool, bool, bool, bool, bool, bool, bool, bool,
                          bool, bool, bool, bool, bool, bool, bool, bool,
                          bool, bool, bool, bool, bool, bool, bool, bool) external;
    function a.getBoolean(uint8) external returns (bool) envfree;
    function a.setBoolean(uint8, bool) external;
    
    // Contract Ao methods (packed booleans)
    function ao.unpackBooleans() external returns (bool, bool, bool, bool, bool, bool, bool, bool,
                                                   bool, bool, bool, bool, bool, bool, bool, bool,
                                                   bool, bool, bool, bool, bool, bool, bool, bool,
                                                   bool, bool, bool, bool, bool, bool, bool, bool) envfree;
    function ao.packBooleans(bool, bool, bool, bool, bool, bool, bool, bool,
                            bool, bool, bool, bool, bool, bool, bool, bool,
                            bool, bool, bool, bool, bool, bool, bool, bool,
                            bool, bool, bool, bool, bool, bool, bool, bool) external;
    function ao.getBoolean(uint8) external returns (bool) envfree;
    function ao.setBoolean(uint8, bool) external;
    function ao.getPackedValue() external returns (uint256) envfree;
    function ao.getBooleans() external returns (bool, bool, bool, bool, bool, bool, bool, bool,
                                                bool, bool, bool, bool, bool, bool, bool, bool,
                                                bool, bool, bool, bool, bool, bool, bool, bool,
                                                bool, bool, bool, bool, bool, bool, bool, bool) envfree;
    function ao.setBooleans(bool, bool, bool, bool, bool, bool, bool, bool,
                           bool, bool, bool, bool, bool, bool, bool, bool,
                           bool, bool, bool, bool, bool, bool, bool, bool,
                           bool, bool, bool, bool, bool, bool, bool, bool) external;
}

/**
 * Definition: Coupling Invariant
 * The core invariant that establishes the bijection between states
 * All 32 booleans in contract A must equal the unpacked booleans from contract Ao
 */
definition couplingInv() returns bool = 
    a.getBooleans() == ao.getBooleans();



/**
 * Main correctness function for gas optimization
 * Proves that operations on both contracts preserve the coupling invariant
 */
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    // Preconditions
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require couplingInv();
    
    // Execute operations
    a.f(eA, args);
    ao.g(eAo, args);
    
    // Postcondition: invariant preserved
    assert couplingInv();

}

/**
 * Rule: Correctness of setBooleans operation
 */
rule gasOptimizedCorrectnessOfSetBooleans(method f, method g)
filtered {
    f -> f.selector == sig:a.setBooleans(bool,bool,bool,bool,bool,bool,bool,bool,
                                         bool,bool,bool,bool,bool,bool,bool,bool,
                                         bool,bool,bool,bool,bool,bool,bool,bool,
                                         bool,bool,bool,bool,bool,bool,bool,bool).selector,
    g -> g.selector == sig:ao.setBooleans(bool,bool,bool,bool,bool,bool,bool,bool,
                                          bool,bool,bool,bool,bool,bool,bool,bool,
                                          bool,bool,bool,bool,bool,bool,bool,bool,
                                          bool,bool,bool,bool,bool,bool,bool,bool).selector
} {
    gasOptimizationCorrectness(f, g);
}

/**
 * Rule: Correctness of setBoolean operation
 */
rule gasOptimizedCorrectnessOfSetBoolean(method f, method g)
filtered {
    f -> f.selector == sig:a.setBoolean(uint8,bool).selector,
    g -> g.selector == sig:ao.setBoolean(uint8,bool).selector
} {
    gasOptimizationCorrectness(f, g);
}

/**
 * Rule: Individual boolean consistency
 * Proves that getting individual booleans returns the same value
 */
rule individualBooleanConsistency(uint8 index) {
    require couplingInv();
    require index >= 1 && index <= 32;
    
    bool valueA = a.getBoolean(index);
    bool valueAo = ao.getBoolean(index);
    
    assert valueA == valueAo;
}

/**
 * Rule: Set and get individual boolean preserves invariant
 */
rule setGetBooleanPreservesInvariant(uint8 index, bool value) {
    env e;
    
    require couplingInv();
    require extendedCouplingInv();
    require index >= 1 && index <= 32;
    
    // Set the same boolean in both contracts
    a.setBoolean(e, index, value);
    ao.setBoolean(e, index, value);
    
    // Verify invariant is preserved
    assert couplingInv();
    
    // Verify the specific boolean was set correctly
    assert a.getBoolean(index) == value;
    assert ao.getBoolean(index) == value;
}
