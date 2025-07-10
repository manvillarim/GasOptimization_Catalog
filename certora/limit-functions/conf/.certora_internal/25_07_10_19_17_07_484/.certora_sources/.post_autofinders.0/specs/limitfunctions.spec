using A as a;
using Ao as ao;

methods {
    function a.getValue() external returns (uint256) envfree;
    function ao.getValue() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.getValue() == ao.getValue();

rule gasOptimizedCorrectnessOfSetValue(uint256 val) {
    env e;
    require couplingInv();

    a.setValue(e, val);
    ao.modifyValue(e, ao.Operation.SET, val);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfIncrementValue(uint256 dummy) {
    env e;
    require couplingInv();

    a.incrementValue(e);
    ao.modifyValue(e, ao.Operation.INCREMENT, dummy);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfDecrementValue(uint256 dummy) {
    env e;
    require couplingInv();

    a.decrementValue(e);
    ao.modifyValue(e, ao.Operation.DECREMENT, dummy);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfMultiplyValue(uint256 multiplier) {
    env e;
    require couplingInv();

    a.multiplyValue(e, multiplier);
    ao.modifyValue(e, ao.Operation.MULTIPLY, multiplier);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfDivideValue(uint256 divisor) {
    env e;
    require couplingInv();

    a.divideValue(e, divisor);
    ao.modifyValue(e, ao.Operation.DIVIDE, divisor);

    assert couplingInv();
}