using A as a;
using Ao as ao;

methods {
    // Method declarations for value getters
    function a.getValue() external returns (uint256) envfree;
    function ao.getValue() external returns (uint256) envfree;
    
}

definition couplingInv() returns bool =
    a.getValue() == ao.getValue();

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

rule gasOptimizedCorrectnessOfSetValue(uint256 _value)
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.setValue(eA, _value);
    ao.modifyValue(eAo, Ao.Operation.SET, _value);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfIncrementValue()
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.incrementValue(eA);
    ao.modifyValue(eAo, Ao.Operation.INCREMENT, 0);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfDecrementValue()
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.decrementValue(eA);
    ao.modifyValue(eAo, Ao.Operation.DECREMENT, 0);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfMultiplyValue(uint256 multiplier)
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.multiplyValue(eA, multiplier);
    ao.modifyValue(eAo, Ao.Operation.MULTIPLY, multiplier);

    assert couplingInv();
}

// Rule for 'divideValue' vs 'modifyValue(DIVIDE, divisor)'
rule gasOptimizedCorrectnessOfDivideValue(uint256 divisor)
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();
    
    require divisor != 0;

    a.divideValue(eA, divisor);
    ao.modifyValue(eAo, Ao.Operation.DIVIDE, divisor);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfSetValueFiltered(method f, method g)
filtered {
    f -> f.selector == sig:a.setValue(uint256).selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    env eA;
    env eAo;
    uint256 _value;

    require eA == eAo && couplingInv();

    a.f(eA, _value);
    ao.g(eAo, Ao.Operation.SET, _value);

    assert couplingInv();
}

invariant couplingMaintained()
    couplingInv();