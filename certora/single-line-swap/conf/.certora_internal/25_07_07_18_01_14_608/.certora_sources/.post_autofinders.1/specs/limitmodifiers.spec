using A as a;
using Ao as ao;

methods {
    // Method declarations for authorization checking
    function a.getAuthorized(address) external returns (bool) envfree;
    function ao.getAuthorized(address) external returns (bool) envfree;
    
    // Method declarations for other contract state variables
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.paused() external returns (bool) envfree;
    function ao.paused() external returns (bool) envfree;
    function a.total() external returns (uint) envfree;
    function ao.total() external returns (uint) envfree;
    function a.count() external returns (uint) envfree;
    function ao.count() external returns (uint) envfree;
    function a.getNumbersLength() external returns (uint) envfree;
    function ao.getNumbersLength() external returns (uint) envfree;
    function a.numbers(uint256) external returns (uint256) envfree;
    function ao.numbers(uint256) external returns (uint256) envfree;
}

// Coupling invariant: defines the expected relationship between A and Ao states
definition couplingInv() returns bool =
    a.owner == ao.owner &&
    a.paused == ao.paused &&
    a.total == ao.total &&
    a.count == ao.count &&
    a.numbers.length == ao.numbers.length &&
    (
        a.numbers.length == 0 ||
        (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i]))
    );
// Helper function to verify if two specific addresses have the same authorization status
function authorizationMatches(address addr) returns bool {
    return a.getAuthorized(addr) == ao.getAuthorized(addr);
}

// Generic function to verify optimization correctness
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    // Environments and initial state must be the same and satisfy coupling invariant
    require eA == eAo && couplingInv();

    // Execute methods on A and Ao
    a.f(eA, args);
    ao.g(eAo, args);

    // After execution, coupling invariant must be maintained
    assert couplingInv();
}

// Specific rule to verify authorization consistency in methods that modify the authorized mapping
rule authorizationConsistency(address addr) {
    env e;
    
    // Initial state: both contracts must have the same authorization state
    require authorizationMatches(addr);
    require couplingInv();
    
    // Test authorize method
    a.authorize(e, addr);
    ao.authorize(e, addr);
    
    assert authorizationMatches(addr);
    assert couplingInv();
}

rule unauthorizationConsistency(address addr) {
    env e;
    
    // Initial state: both contracts must have the same authorization state
    require authorizationMatches(addr);
    require couplingInv();
    
    // Test unauthorize method
    a.unauthorize(e, addr);
    ao.unauthorize(e, addr);
    
    assert authorizationMatches(addr);
    assert couplingInv();
}

// Rule for 'criticalFunction'
rule gasOptimizedCorrectnessOfCriticalFunction(method f, method g)
filtered {
    f -> f.selector == sig:a.criticalFunction(address).selector,
    g -> g.selector == sig:ao.criticalFunction(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for 'authorize'
rule gasOptimizedCorrectnessOfAuthorize(method f, method g)
filtered {
    f -> f.selector == sig:a.authorize(address).selector,
    g -> g.selector == sig:ao.authorize(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for 'unauthorize'
rule gasOptimizedCorrectnessOfUnauthorize(method f, method g)
filtered {
    f -> f.selector == sig:a.unauthorize(address).selector,
    g -> g.selector == sig:ao.unauthorize(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for 'setPaused'
rule gasOptimizedCorrectnessOfSetPaused(method f, method g)
filtered {
    f -> f.selector == sig:a.setPaused(bool).selector,
    g -> g.selector == sig:ao.setPaused(bool).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rules for additional methods added for CVL
rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g)
filtered {
    f -> f.selector == sig:a.processNumbers(uint).selector,
    g -> g.selector == sig:ao.processNumbers(uint).selector
} {
    gasOptimizationCorrectness(f, g);
}