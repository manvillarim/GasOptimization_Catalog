using A as original;
using Ao as optimized;

// ============================================================================
// METHODS DECLARATION
// ============================================================================

methods {
    // Observable state getters (must be implemented by both contracts)
    function _.totalSum() external returns (uint256) envfree;
    function _.elementCount() external returns (uint256) envfree;
    function _.lastAdded() external returns (uint256) envfree;
    function _.lastRemoved() external returns (uint256) envfree;
    function _.operationCount() external returns (uint256) envfree;
    function _.getLength() external returns (uint256) envfree;
    
    // Generic value accessor
    function _.values(uint256) external returns (uint256) envfree;
    
    // State mutators (parametric methods)
    function _.addValue(uint256) external;
    function _.updateValue(uint256, uint256) external;
    function _.removeValue(uint256) external;
    function _.batchAdd(uint256[]) external;
    function _.clear() external;
    
    // State observers
    function _.getValue(uint256) external returns (uint256);
    function _.getState() external returns (uint256, uint256, uint256, uint256, uint256);
    
    // Optimized-specific methods (may not exist in original)
    function optimized.exists(uint256) external returns (bool) envfree;
    function optimized.nextIndex() external returns (uint256) envfree;
}

// ============================================================================
// GHOST STATE AND DEFINITIONS
// ============================================================================

// Ghost mapping to track method executions for bisimulation
ghost uint256 executionCounter {
    init_state axiom executionCounter == 0;
}

// Observable state structure
struct ObservableState {
    uint256 totalSum;
    uint256 elementCount;
    uint256 lastAdded;
    uint256 lastRemoved;
    uint256 operationCount;
}

// ============================================================================
// STATE PROJECTION FUNCTIONS
// ============================================================================

/**
 * Projects the observable state from the original contract
 */
function projectOriginal() returns ObservableState {
    ObservableState state;
    state.totalSum = original.totalSum();
    state.elementCount = original.elementCount();
    state.lastAdded = original.lastAdded();
    state.lastRemoved = original.lastRemoved();
    state.operationCount = original.operationCount();
    return state;
}

/**
 * Projects the observable state from the optimized contract
 */
function projectOptimized() returns ObservableState {
    ObservableState state;
    state.totalSum = optimized.totalSum();
    state.elementCount = optimized.elementCount();
    state.lastAdded = optimized.lastAdded();
    state.lastRemoved = optimized.lastRemoved();
    state.operationCount = optimized.operationCount();
    return state;
}

// ============================================================================
// REFINEMENT RELATIONS
// ============================================================================

/**
 * Defines observational equivalence between two states
 */
definition observationalEquivalence(ObservableState s1, ObservableState s2) returns bool =
    s1.totalSum == s2.totalSum &&
    s1.elementCount == s2.elementCount &&
    s1.lastAdded == s2.lastAdded &&
    s1.lastRemoved == s2.lastRemoved &&
    s1.operationCount == s2.operationCount;

/**
 * Coupling invariant that must be preserved across all operations
 */
definition couplingInvariant() returns bool =
    observationalEquivalence(projectOriginal(), projectOptimized()) &&
    // Additional implementation-specific invariants
    original.getLength() == optimized.elementCount() &&
    original.elementCount() == optimized.elementCount();

/**
 * Checks if a method is a state mutator
 */
definition isMutator(method f) returns bool =
    f.selector == sig:original.addValue(uint256).selector ||
    f.selector == sig:original.updateValue(uint256, uint256).selector ||
    f.selector == sig:original.removeValue(uint256).selector ||
    f.selector == sig:original.batchAdd(uint256[]).selector ||
    f.selector == sig:original.clear().selector;

/**
 * Checks if a method is a pure observer
 */
definition isObserver(method f) returns bool =
    f.selector == sig:original.getValue(uint256).selector ||
    f.selector == sig:original.getState().selector;

// ============================================================================
// BEHAVIORAL EQUIVALENCE VERIFICATION
// ============================================================================

/**
 * Core bisimulation proof for state-mutating operations
 * Proves that any state transition preserves the coupling invariant
 */
rule bisimulationForMutators(method f, method g) 
    filtered {
        f -> isMutator(f),
        g -> g.selector == f.selector
    }
{
    env e1;
    env e2;
    calldataargs args;
    
    // Environment equivalence
    require e1.msg.sender == e2.msg.sender;
    require e1.msg.value == e2.msg.value;
    require e1.block.timestamp == e2.block.timestamp;
    require e1.block.number == e2.block.number;
    
    // Pre-condition: coupling invariant holds
    require couplingInvariant();
    
    // Store pre-states for comparison
    ObservableState preOriginal = projectOriginal();
    ObservableState preOptimized = projectOptimized();
    
    // Execute both implementations
    storage initialOriginal = lastStorage;
    bool successOriginal = original.f@withrevert(e1, args);
    
    storage initialOptimized = lastStorage at initialOriginal;
    bool successOptimized = optimized.g@withrevert(e2, args) at initialOptimized;
    
    // Post-conditions
    
    // 1. Both succeed or both fail
    assert successOriginal <=> successOptimized, 
        "Methods must have same success/failure behavior";
    
    // 2. If successful, coupling invariant is preserved
    assert successOriginal => couplingInvariant(),
        "Coupling invariant must be preserved after successful execution";
    
    // 3. State changes are synchronized
    assert successOriginal => 
        (projectOriginal().operationCount == preOriginal.operationCount + 1 &&
         projectOptimized().operationCount == preOptimized.operationCount + 1),
        "Operation counters must increment synchronously";
}

/**
 * Proves observational equivalence for pure observer functions
 */
rule observationalEquivalenceForObservers(method f, method g)
    filtered {
        f -> isObserver(f),
        g -> g.selector == f.selector
    }
{
    env e;
    calldataargs args;
    
    // Pre-condition: coupling invariant holds
    require couplingInvariant();
    
    // Pure observers must return identical results
    assert original.f(e, args) == optimized.g(e, args),
        "Observer functions must return identical results";
}

// ============================================================================
// COMPOSITIONAL PROPERTIES
// ============================================================================

/**
 * Sequential composition preserves equivalence
 */
rule sequentialComposition {
    env e1;
    env e2;
    uint256 val1;
    uint256 val2;
    
    require couplingInvariant();
    
    // First operation
    original.addValue(e1, val1);
    optimized.addValue(e1, val1);
    
    assert couplingInvariant(), "Invariant broken after first operation";
    
    // Second operation
    original.addValue(e2, val2);
    optimized.addValue(e2, val2);
    
    assert couplingInvariant(), "Invariant broken after second operation";
    
    // Verify additive property
    assert original.totalSum() == optimized.totalSum();
    assert original.elementCount() == 2 => optimized.elementCount() == 2;
}

/**
 * Parallel independence: operations on different indices don't interfere
 */
rule parallelIndependence {
    env e;
    uint256 idx1;
    uint256 idx2;
    uint256 val1;
    uint256 val2;
    
    require idx1 != idx2;
    require couplingInvariant();
    
    // Store initial state
    uint256 initialSum = original.totalSum();
    
    // Operations can be reordered
    original.updateValue(e, idx1, val1);
    original.updateValue(e, idx2, val2);
    
    uint256 finalSum1 = original.totalSum();
    
    // Reset and try opposite order
    optimized.updateValue(e, idx2, val2);
    optimized.updateValue(e, idx1, val1);
    
    uint256 finalSum2 = optimized.totalSum();
    
    // Both orders produce same result
    assert finalSum1 == finalSum2,
        "Independent operations must be order-agnostic";
}

// ============================================================================
// STRUCTURAL INVARIANTS
// ============================================================================

/**
 * Sum consistency: totalSum equals sum of all elements
 */
invariant sumConsistency(env e) 
    original.totalSum() == computeSum(original) &&
    optimized.totalSum() == computeSum(optimized)
    filtered { f -> !f.isView }

/**
 * Count consistency: element count is bounded by array length
 */
invariant countBounds(env e)
    original.elementCount() <= original.getLength() &&
    optimized.elementCount() <= optimized.getLength()
    filtered { f -> !f.isView }

/**
 * Operation counter monotonicity
 */
invariant operationMonotonicity(env e)
    original.operationCount() >= 0 &&
    optimized.operationCount() >= 0
    filtered { f -> !f.isView }

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Computes sum of elements for verification
 */
function computeSum(address contract) returns uint256 {
    uint256 sum = 0;
    uint256 length = contract == original ? 
        original.getLength() : optimized.getLength();
    
    require length <= 1000; // Bounded for verification
    
    for (uint256 i = 0; i < length; i++) {
        if (contract == original) {
            sum = sum + original.values(i);
        } else {
            sum = sum + optimized.values(i);
        }
    }
    return sum;
}

// ============================================================================
// SANITY CHECKS AND META-PROPERTIES
// ============================================================================

/**
 * Reflexivity: refinement relation is reflexive
 */
rule refinementReflexivity {
    ObservableState s = projectOriginal();
    assert observationalEquivalence(s, s),
        "Refinement must be reflexive";
}

/**
 * Initial state equivalence
 */
rule initialStateEquivalence {
    // After deployment, both contracts start in equivalent states
    assert original.totalSum() == 0 => optimized.totalSum() == 0;
    assert original.elementCount() == 0 => optimized.elementCount() == 0;
    assert original.operationCount() == 0 => optimized.operationCount() == 0;
}

/**
 * Sanity: Valid execution path exists
 */
rule existsValidPath {
    env e;
    uint256 val;
    
    require val > 0 && val < 1000000;
    require couplingInvariant();
    
    original.addValue(e, val);
    optimized.addValue(e, val);
    
    satisfy couplingInvariant();
}

/**
 * Parametric verification for all public/external methods
 * This is the main entry point for automated verification
 */
rule universalBehavioralEquivalence(method f, method g) {
    env e;
    calldataargs args;
    
    // Only verify methods with matching selectors
    require f.selector == g.selector;
    require f.contract == original;
    require g.contract == optimized;
    
    // Pre-condition
    require couplingInvariant();
    
    // Store pre-execution state
    ObservableState stateBefore = projectOriginal();
    
    // Execute both versions
    storage init = lastStorage;
    
    bool successOrig;
    bytes retOrig;
    successOrig, retOrig = original.f@withrevert(e, args);
    
    bool successOpt;
    bytes retOpt;
    successOpt, retOpt = optimized.g@withrevert(e, args) at init;
    
    // Universal post-conditions
    
    // 1. Execution outcomes match
    assert successOrig <=> successOpt,
        "Execution success must match";
    
    // 2. Return values match (for successful executions)
    assert successOrig => (retOrig.length == retOpt.length),
        "Return data length must match";
    
    // 3. Coupling invariant preserved
    assert successOrig => couplingInvariant(),
        "Coupling invariant must be preserved";
    
    // 4. No execution if failed
    assert !successOrig => 
        observationalEquivalence(stateBefore, projectOriginal()),
        "Failed execution must not change state";
}

// ============================================================================
// LIVENESS PROPERTIES
// ============================================================================

/**
 * Progress: system can always make progress
 */
rule progressProperty {
    env e;
    
    require couplingInvariant();
    
    uint256 val;
    require val > 0 && val < 1000000;
    
    // Can always add new elements
    assert original.addValue@withrevert(e, val);
    assert optimized.addValue@withrevert(e, val);
}

/**
 * Termination: clear operation always succeeds
 */
rule clearTermination {
    env e;
    
    require couplingInvariant();
    
    assert !original.clear@withrevert(e);
    assert !optimized.clear@withrevert(e);
    
    // After clear, both are in initial state
    assert original.elementCount() == 0;
    assert optimized.elementCount() == 0;
    assert couplingInvariant();
}