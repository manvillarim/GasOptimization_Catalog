using A as ini;
using Ao as fnl;

methods {
    function ini.getData() external returns uint256 envfree;
    function fnl.getData() external returns uint256 envfree;
    function ini.users(uint256) external returns (string, uint256, bool) envfree;
    function fnl.users(uint256) external returns (string, uint256, bool) envfree;
    function ini.getUsersLength() external returns uint256 envfree;
    function fnl.getUsersLength() external returns uint256 envfree;
}

definition couplingInv() returns bool = 
    ini.getData() == fnl.getData() &&
    ini.getUsersLength() == fnl.getUsersLength() &&
    (forall uint256 i. i < ini.getUsersLength() => 
        (ini.users(i).balance == fnl.users(i).balance && 
         ini.users(i).active == fnl.users(i).active));

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