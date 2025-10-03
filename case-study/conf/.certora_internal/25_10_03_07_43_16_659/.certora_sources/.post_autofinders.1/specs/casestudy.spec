using A as a;
using Ao as ao;


methods {
    // RewardsDistributor wrapper methods
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    
    function a.getRewardsList() external returns (address[]) envfree;
    function ao.getRewardsList() external returns (address[]) envfree;
    
    function a.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    function ao.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    true;
    
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfGetUserAccruedRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAccruedRewards(address, address).selector,
    g -> g.selector == sig:ao.getUserAccruedRewards(address, address).selector
} {
    env e;
    address user;
    address reward;
    
    // ===== ESTADO ANTES =====
    // Acessar listas internas diretamente
    address[] rewardsListBefore_a = a.rewardsDistributor._rewardsList;
    address[] rewardsListBefore_ao = ao.rewardsDistributor._rewardsList;
    
    address[] assetsListBefore_a = a.rewardsDistributor._assetsList;
    address[] assetsListBefore_ao = ao.rewardsDistributor._assetsList;
    
    uint256 rewardsCountBefore_a = rewardsListBefore_a.length;
    uint256 rewardsCountBefore_ao = rewardsListBefore_ao.length;
    
    uint256 assetsCountBefore_a = assetsListBefore_a.length;
    uint256 assetsCountBefore_ao = assetsListBefore_ao.length;
    
    // ===== PRECONDIÇÕES =====
    // Verificar que os ambientes são equivalentes
    require rewardsCountBefore_a == rewardsCountBefore_ao;
    require assetsCountBefore_a == assetsCountBefore_ao;
    
    // As listas devem ser idênticas
    require forall uint256 i. (i < rewardsCountBefore_a => 
        rewardsListBefore_a[i] == rewardsListBefore_ao[i]);
    
    require forall uint256 i. (i < assetsCountBefore_a => 
        assetsListBefore_a[i] == assetsListBefore_ao[i]);
    
    // Para cada asset na lista, verificar que os dados accrued são iguais
    require forall uint256 i. (i < assetsCountBefore_a => 
        a.rewardsDistributor._assets[assetsListBefore_a[i]].rewards[reward].usersData[user].accrued == 
        ao.rewardsDistributor._assets[assetsListBefore_ao[i]].rewards[reward].usersData[user].accrued
    );
    
    // Verificar que os índices dos usuários são iguais
    require forall uint256 i. (i < assetsCountBefore_a => 
        a.rewardsDistributor._assets[assetsListBefore_a[i]].rewards[reward].usersData[user].index == 
        ao.rewardsDistributor._assets[assetsListBefore_ao[i]].rewards[reward].usersData[user].index
    );
    
    // ===== EXECUÇÃO =====
    uint256 result_a = a.getUserAccruedRewards(e, user, reward);
    uint256 result_ao = ao.getUserAccruedRewards(e, user, reward);
    
    // ===== ESTADO DEPOIS =====
    address[] rewardsListAfter_a = a.rewardsDistributor._rewardsList;
    address[] rewardsListAfter_ao = ao.rewardsDistributor._rewardsList;
    
    address[] assetsListAfter_a = a.rewardsDistributor._assetsList;
    address[] assetsListAfter_ao = ao.rewardsDistributor._assetsList;
    
    uint256 rewardsCountAfter_a = rewardsListAfter_a.length;
    uint256 rewardsCountAfter_ao = rewardsListAfter_ao.length;
    
    uint256 assetsCountAfter_a = assetsListAfter_a.length;
    uint256 assetsCountAfter_ao = assetsListAfter_ao.length;
    
    // ===== VERIFICAÇÕES DE INVARIANTES =====
    // Função view não deve modificar listas
    assert rewardsCountBefore_a == rewardsCountAfter_a;
    assert rewardsCountBefore_ao == rewardsCountAfter_ao;
    assert assetsCountBefore_a == assetsCountAfter_a;
    assert assetsCountBefore_ao == assetsCountAfter_ao;
    
    // Listas devem permanecer idênticas
    assert forall uint256 i. (i < rewardsCountAfter_a => 
        rewardsListAfter_a[i] == rewardsListAfter_ao[i]);
    
    assert forall uint256 i. (i < assetsCountAfter_a => 
        assetsListAfter_a[i] == assetsListAfter_ao[i]);
    
    // Dados accrued não devem ter sido modificados
    assert forall uint256 i. (i < assetsCountAfter_a => 
        a.rewardsDistributor._assets[assetsListAfter_a[i]].rewards[reward].usersData[user].accrued == 
        ao.rewardsDistributor._assets[assetsListAfter_ao[i]].rewards[reward].usersData[user].accrued
    );
    
    // ===== VERIFICAÇÃO PRINCIPAL =====
    assert result_a == result_ao;
}


// Rule for getAllUserRewards
rule gasOptimizedCorrectnessOfGetAllUserRewards(method f, method g) 
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    gasOptimizationCorrectness(f, g);
}