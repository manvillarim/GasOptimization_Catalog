using A as ini;
using Ao as fnl;

methods {
    function ini.getData() external returns uint256 envfree;
    function fnl.getData() external returns uint256 envfree;
    function ini.getUsersLength() external returns uint256 envfree;
    function fnl.getUsersLength() external returns uint256 envfree;
    function ini.getTotalBalance() external returns uint256 envfree;
    function fnl.getTotalBalance() external returns uint256 envfree;
    function ini.getActiveCount() external returns uint256 envfree;
    function fnl.getActiveCount() external returns uint256 envfree;
}

definition couplingInv() returns bool = 
    ini.getUsersLength() == fnl.getUsersLength() &&
    ini.getTotalBalance() == fnl.getTotalBalance() &&
    ini.getActiveCount() == fnl.getActiveCount() &&
    ini.getData() == fnl.getData();

rule gasOptimizationForSpecificFunction(method f, method g)
filtered { 
    f -> !f.isView && f.contract == ini && !f.isPure && !f.isFallback &&
         (f.selector == sig:addUser(string memory, uint, bool).selector ||
          f.selector == sig:processUsers().selector),
    g -> !g.isView && g.contract == fnl && !g.isPure && !g.isFallback &&
         (g.selector == sig:addUser(string memory, uint, bool).selector ||
          g.selector == sig:processUsers().selector)
} {
    
    // Agora podemos garantir que são a mesma função
    require g.selector == f.selector;
    
    env e1; env e2;
    calldataarg args;
    
    require couplingInv();
    require e1.msg.sender == e2.msg.sender;
    require e1.msg.value == e2.msg.value;
    
    storage initialState = lastStorage;
    
    ini.f(e1, args) at initialState;
    fnl.g(e2, args) at initialState;
    
    assert couplingInv();
}