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
