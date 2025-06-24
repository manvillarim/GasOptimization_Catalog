using A as ini;
using Ao as fnl;

methods {
    function ini.getData() external returns uint256 envfree;
    function fnl.getData() external returns uint256 envfree;
    function ini.getUserBalance(uint256) external returns uint256 envfree;
    function fnl.getUserBalance(uint256) external returns uint256 envfree;
    function ini.getUserActive(uint256) external returns bool envfree;
    function fnl.getUserActive(uint256) external returns bool envfree;
    function ini.getUsersLength() external returns uint256 envfree;
    function fnl.getUsersLength() external returns uint256 envfree;
}

definition couplingInv() returns bool = 
    ini.getData() == fnl.getData() &&
    ini.getUsersLength() == fnl.getUsersLength() &&
    (forall uint256 i. i < ini.getUsersLength() => 
        (ini.getUserBalance(i) == fnl.getUserBalance(i) && 
         ini.getUserActive(i) == fnl.getUserActive(i)));

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