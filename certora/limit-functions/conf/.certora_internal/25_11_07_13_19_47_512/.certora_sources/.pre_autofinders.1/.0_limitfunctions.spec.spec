using A as a;
using Ao as ao;

methods {
    function a.getValue() external returns (uint256) envfree;
    function ao.getValue() external returns (uint256) envfree;
    
    function a.setValue(uint256) external;
    function a.incrementValue() external;
    function a.decrementValue() external;
    function a.multiplyValue(uint256) external;
    function a.divideValue(uint256) external;
    
    function ao.modifyValue(Ao.Operation, uint256) external;
}

definition couplingInv() returns bool =
    a.getValue() == ao.getValue();


function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();

    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;

    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfIncrementValue()
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.incrementValue@withrevert(eA);
    bool a_reverted = lastReverted;
    ao.modifyValue@withrevert(eAo, Ao.Operation.INCREMENT, 0);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfDecrementValue()
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.decrementValue@withrevert(eA);
    bool a_reverted = lastReverted;
    ao.modifyValue@withrevert(eAo, Ao.Operation.DECREMENT, 0);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfMultiplyValue(uint256 multiplier)
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.multiplyValue@withrevert(eA, multiplier);
    bool a_reverted = lastReverted;
    ao.modifyValue@withrevert(eAo, Ao.Operation.MULTIPLY, multiplier);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfDivideValue(uint256 divisor)
{
    env eA;
    env eAo;

    require eA == eAo && couplingInv();

    a.divideValue@withrevert(eA, divisor);
    bool a_reverted = lastReverted;
    ao.modifyValue@withrevert(eAo, Ao.Operation.DIVIDE, divisor);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}
