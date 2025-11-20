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

rule gasOptimizationCorrectnessGeneralized(method f)
filtered { f -> !f.isView && !f.isPure && !f.isFallback } {
    
    env e;
    calldataarg args;
    
    require couplingInv();
    
    // Chama a mesma função em ambos os contratos
    storage initialStorage = lastStorage;
    
    // Executa no contrato original
    ini.f(e, args) at initialStorage;
    
    // Executa no contrato otimizado com o mesmo estado inicial
    fnl.f(e, args) at initialStorage;
    
    // Verifica se o invariante de acoplamento ainda é válido
    assert couplingInv();
}