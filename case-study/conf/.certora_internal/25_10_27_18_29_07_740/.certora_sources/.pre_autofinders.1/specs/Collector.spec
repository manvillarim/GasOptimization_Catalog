using CollectorOriginal as a;
using CollectorOptimized as ao;

methods {
    // ====================================
    // SUMMARIES PARA EVITAR HAVOC
    // ====================================
    
    // Summary para IERC20.approve - retorna sempre true
    function _.approve(address, uint256) external => ALWAYS(true);
    
    // Summary para IERC20.transfer - retorna baseado em ghost
    function _.transfer(address, uint256) external => ghostTransferSuccess[calledContract] expect bool;
    
    // Summary para IERC20.transferFrom
    function _.transferFrom(address, address, uint256) external => ghostTransferFromSuccess[calledContract] expect bool;
    
    // ====================================
    // MÉTODOS ENVFREE DO COLLECTOR
    // ====================================
    
    function a.isFundsAdmin(address) external returns (bool) envfree;
    function ao.isFundsAdmin(address) external returns (bool) envfree;
    
    function a.getNextStreamId() external returns (uint256) envfree;
    function ao.getNextStreamId() external returns (uint256) envfree;
    
    function a.hasRole(bytes32, address) external returns (bool) envfree;
    function ao.hasRole(bytes32, address) external returns (bool) envfree;
    
    function a.getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree;
    function ao.getStream(uint256) external returns (address, address, uint256, address, uint256, uint256, uint256, uint256) envfree;
    
    function a.balanceOf(uint256, address) external returns (uint256) envfree;
    function ao.balanceOf(uint256, address) external returns (uint256) envfree;
    
    function a.deltaOf(uint256) external returns (uint256) envfree;
    function ao.deltaOf(uint256) external returns (uint256) envfree;
}

// ====================================
// GHOST VARIABLES APENAS PARA TOKENS
// ====================================

// Ghost para controlar sucesso de transfers
ghost mapping(address => bool) ghostTransferSuccess {
    init_state axiom forall address token. ghostTransferSuccess[token] == true;
}

// Ghost para controlar sucesso de transferFrom
ghost mapping(address => bool) ghostTransferFromSuccess {
    init_state axiom forall address token. ghostTransferFromSuccess[token] == true;
}

// ====================================
// INVARIANTE DE ACOPLAMENTO
// ====================================

definition couplingInv() returns bool =
    // _nextStreamId deve ser igual
    a.getNextStreamId() == ao.getNextStreamId() &&
    
    // Streams devem ser iguais para todos os IDs
    (forall uint256 streamId.
        // Verificar se ambos existem ou ambos não existem
        (a.getStream(streamId)[0] == 0 && ao.getStream(streamId)[0] == 0) ||
        (
            a.getStream(streamId)[0] == ao.getStream(streamId)[0] &&  // sender
            a.getStream(streamId)[1] == ao.getStream(streamId)[1] &&  // recipient
            a.getStream(streamId)[2] == ao.getStream(streamId)[2] &&  // deposit
            a.getStream(streamId)[3] == ao.getStream(streamId)[3] &&  // tokenAddress
            a.getStream(streamId)[4] == ao.getStream(streamId)[4] &&  // startTime
            a.getStream(streamId)[5] == ao.getStream(streamId)[5] &&  // stopTime
            a.getStream(streamId)[6] == ao.getStream(streamId)[6] &&  // remainingBalance
            a.getStream(streamId)[7] == ao.getStream(streamId)[7]     // ratePerSecond
        )
    ) &&
    
    // Roles devem ser iguais
    (forall bytes32 role. forall address account.
        a.hasRole(role, account) == ao.hasRole(role, account)
    );

// ====================================
// FUNÇÃO DE VERIFICAÇÃO GENÉRICA
// ====================================

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    // Ambientes devem ser idênticos
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    
    // Estado inicial deve ser equivalente
    require couplingInv();
    
    // Precondições para garantir comportamento consistente dos tokens
    require forall address token. 
        ghostTransferSuccess[token] == ghostTransferSuccess[token];
    require forall address token.
        ghostTransferFromSuccess[token] == ghostTransferFromSuccess[token];
    
    // Executar as funções
    a.f(eA, args);
    ao.g(eAo, args);
    
    // Estado final deve ser equivalente
    assert couplingInv();
}

// ====================================
// REGRAS DE VERIFICAÇÃO
// ====================================

rule gasOptimizedCorrectnessOfApprove(method f, method g)
filtered {
    f -> f.selector == sig:a.approve(address, address, uint256).selector,
    g -> g.selector == sig:ao.approve(address, address, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfTransfer(method f, method g)
filtered {
    f -> f.selector == sig:a.transfer(address, address, uint256).selector,
    g -> g.selector == sig:ao.transfer(address, address, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:a.createStream(address, uint256, address, uint256, uint256).selector,
    g -> g.selector == sig:ao.createStream(address, uint256, address, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdrawFromStream(method f, method g)
filtered {
    f -> f.selector == sig:a.withdrawFromStream(uint256, uint256).selector,
    g -> g.selector == sig:ao.withdrawFromStream(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCancelStream(method f, method g)
filtered {
    f -> f.selector == sig:a.cancelStream(uint256).selector,
    g -> g.selector == sig:ao.cancelStream(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfDeltaOf(method f, method g)
filtered {
    f -> f.selector == sig:a.deltaOf(uint256).selector,
    g -> g.selector == sig:ao.deltaOf(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBalanceOf(method f, method g)
filtered {
    f -> f.selector == sig:a.balanceOf(uint256, address).selector,
    g -> g.selector == sig:ao.balanceOf(uint256, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIsFundsAdmin(method f, method g)
filtered {
    f -> f.selector == sig:a.isFundsAdmin(address).selector,
    g -> g.selector == sig:ao.isFundsAdmin(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetNextStreamId(method f, method g)
filtered {
    f -> f.selector == sig:a.getNextStreamId().selector,
    g -> g.selector == sig:ao.getNextStreamId().selector
} {
    gasOptimizationCorrectness(f, g);
}