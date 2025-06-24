using A as ini;
using Ao as fnl;

methods {
    function ini.getData() external returns uint256 envfree;
    function fnl.getData() external returns uint256 envfree;
}

definition couplingInv() returns bool = ini.getData() == fnl.getData();

rule gasOptimizationCorrectness(bool order, method f, method g)
filtered { f -> !f.isView, g -> !g.isView } {
    require f.selector == g.selector;
    env eOrig;
    env eNew;
    calldataarg args;
    require couplingInv();
    if (order) {
        ini.f(eOrig, args);
        fnl.g(eNew, args);
    } else {
        fnl.g(eOrig, args);
        ini.f(eNew, args);
    }
    assert couplingInv();
}