using A as a;
using Ao as ao;

methods {
    function a.loop(uint256 n) external;
    function ao.loop(uint256 n) external;

    function a.getData() external returns (uint256) envfree;
    function ao.getData() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.getData() == ao.getData();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfLoop(method f, method g)
    filtered {
        f -> f.selector == sig:a.loop(uint256).selector,
        g -> g.selector == sig:ao.loop(uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}
