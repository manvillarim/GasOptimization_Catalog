using A as a;
using Ao as ao;

methods {
    // GenericLogic methods
    function a.calculateUserAccountData() external returns (uint256, uint256, uint256, uint256, uint256, bool) envfree;
    function ao.calculateUserAccountData() external returns (uint256, uint256, uint256, uint256, uint256, bool) envfree;
}

definition couplingInv() returns bool =
    // GenericLogic state coupling
    (forall address asset.
        a.reservesData_GL[asset].configuration.data == ao.reservesData_GL[asset].configuration.data &&
        a.reservesData_GL[asset].liquidityIndex == ao.reservesData_GL[asset].liquidityIndex &&
        a.reservesData_GL[asset].currentLiquidityRate == ao.reservesData_GL[asset].currentLiquidityRate &&
        a.reservesData_GL[asset].variableBorrowIndex == ao.reservesData_GL[asset].variableBorrowIndex &&
        a.reservesData_GL[asset].currentVariableBorrowRate == ao.reservesData_GL[asset].currentVariableBorrowRate &&
        a.reservesData_GL[asset].currentStableBorrowRate == ao.reservesData_GL[asset].currentStableBorrowRate &&
        a.reservesData_GL[asset].lastUpdateTimestamp == ao.reservesData_GL[asset].lastUpdateTimestamp &&
        a.reservesData_GL[asset].id == ao.reservesData_GL[asset].id &&
        a.reservesData_GL[asset].aTokenAddress == ao.reservesData_GL[asset].aTokenAddress &&
        a.reservesData_GL[asset].stableDebtTokenAddress == ao.reservesData_GL[asset].stableDebtTokenAddress &&
        a.reservesData_GL[asset].variableDebtTokenAddress == ao.reservesData_GL[asset].variableDebtTokenAddress &&
        a.reservesData_GL[asset].interestRateStrategyAddress == ao.reservesData_GL[asset].interestRateStrategyAddress
    ) &&
    (forall uint256 id.
        a.reservesList_GL[id] == ao.reservesList_GL[id]
    ) &&
    (forall uint8 categoryId.
        a.eModeCategories_GL[categoryId].ltv == ao.eModeCategories_GL[categoryId].ltv &&
        a.eModeCategories_GL[categoryId].liquidationThreshold == ao.eModeCategories_GL[categoryId].liquidationThreshold &&
        a.eModeCategories_GL[categoryId].liquidationBonus == ao.eModeCategories_GL[categoryId].liquidationBonus &&
        a.eModeCategories_GL[categoryId].priceSource == ao.eModeCategories_GL[categoryId].priceSource &&
        a.eModeCategories_GL[categoryId].label == ao.eModeCategories_GL[categoryId].label
    ) &&
    // Account params must be the same
    a.accountParams.userConfig.data == ao.accountParams.userConfig.data &&
    a.accountParams.reservesCount == ao.accountParams.reservesCount &&
    a.accountParams.user == ao.accountParams.user &&
    a.accountParams.oracle == ao.accountParams.oracle &&
    a.accountParams.userEModeCategory == ao.accountParams.userEModeCategory;

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

// Rule for GenericLogic.calculateUserAccountData
rule gasOptimizedCorrectnessOfCalculateUserAccountData
 filtered {
    f -> f.selector == sig:a.getState().selector,
    g -> g.selector == sig:ao.getState().selector
} {
    gasOptimizationCorrectness(f, g);
}