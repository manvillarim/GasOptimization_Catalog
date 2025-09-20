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

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}

rule gasOptimizedCorrectnessOfSetValue(method f, method g)
filtered {
    f -> f.selector == sig:a.setValue(uint256).selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIncrementValue(method f, method g)
filtered {
    f -> f.selector == sig:a.incrementValue().selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDecrementValue(method f, method g)
filtered {
    f -> f.selector == sig:a.decrementValue().selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfMultiplyValue(method f, method g)
filtered {
    f -> f.selector == sig:a.multiplyValue(uint256).selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDivideValue(method f, method g)
filtered {
    f -> f.selector == sig:a.divideValue(uint256).selector,
    g -> g.selector == sig:ao.modifyValue(Ao.Operation, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}
