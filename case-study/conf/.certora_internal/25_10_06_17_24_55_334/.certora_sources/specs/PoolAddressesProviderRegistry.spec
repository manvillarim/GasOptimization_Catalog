// SPDX-License-Identifier: BUSL-1.1
// Especificação CVL para PoolAddressesProviderRegistry

using RegistryOriginal as a;
using RegistryOptimized as ao;

methods {
    // State-changing functions
    function a.registerAddressesProvider(address, uint256) external;
    function ao.registerAddressesProvider(address, uint256) external;
    
    function a.unregisterAddressesProvider(address) external;
    function ao.unregisterAddressesProvider(address) external;
    
    // View functions
    function a.getAddressesProvidersList() external returns (address[]) envfree;
    function ao.getAddressesProvidersList() external returns (address[]) envfree;
    
    function a.getAddressesProviderIdByAddress(address) external returns (uint256) envfree;
    function ao.getAddressesProviderIdByAddress(address) external returns (uint256) envfree;
    
    function a.getAddressesProviderAddressById(uint256) external returns (address) envfree;
    function ao.getAddressesProviderAddressById(uint256) external returns (address) envfree;
}

definition couplingInv() returns bool =
    // Para cada provider, o ID deve ser igual
    (forall address provider.
        a._addressesProviderToId[provider] == ao._addressesProviderToId[provider]
    ) &&
    
    // Para cada ID, o provider deve ser igual
    (forall uint256 id.
        a._idToAddressesProvider[id] == ao._idToAddressesProvider[id]
    ) &&
    
    // Lista de providers deve ter mesmo tamanho
    a._addressesProvidersList.length == ao._addressesProvidersList.length &&
    
    // Lista de providers deve ter mesmos elementos
    (forall uint256 i.
        i < a._addressesProvidersList.length =>
        a._addressesProvidersList[i] == ao._addressesProvidersList[i]
    ) &&
    
    // Índices dos providers na lista devem ser iguais
    (forall address provider.
        a._addressesProvidersIndexes[provider] == ao._addressesProvidersIndexes[provider]
    );

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

// ============================================================
// REGRAS - STATE-CHANGING FUNCTIONS
// ============================================================

rule gasOptimizedCorrectnessOfRegisterAddressesProvider(method f, method g)
filtered {
    f -> f.selector == sig:a.registerAddressesProvider(address, uint256).selector,
    g -> g.selector == sig:ao.registerAddressesProvider(address, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUnregisterAddressesProvider(method f, method g)
filtered {
    f -> f.selector == sig:a.unregisterAddressesProvider(address).selector,
    g -> g.selector == sig:ao.unregisterAddressesProvider(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// ============================================================
// REGRAS - VIEW FUNCTIONS
// ============================================================

rule gasOptimizedCorrectnessOfGetAddressesProvidersList(method f, method g)
filtered {
    f -> f.selector == sig:a.getAddressesProvidersList().selector,
    g -> g.selector == sig:ao.getAddressesProvidersList().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAddressesProviderIdByAddress(method f, method g)
filtered {
    f -> f.selector == sig:a.getAddressesProviderIdByAddress(address).selector,
    g -> g.selector == sig:ao.getAddressesProviderIdByAddress(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAddressesProviderAddressById(method f, method g)
filtered {
    f -> f.selector == sig:a.getAddressesProviderAddressById(uint256).selector,
    g -> g.selector == sig:ao.getAddressesProviderAddressById(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}