using CollectorOriginal as a;
using CollectorOptimized as ao;

methods {
    // ====================================
    // SUMMARIES PARA EVITAR HAVOC
    // ====================================
    
    // Summary para IERC20.approve - retorna sempre true e não modifica estado global
    function _.approve(address, uint256) external => ALWAYS(true);
    
    // Summary para IERC20.transfer - retorna true/false baseado em ghosts
    function _.transfer(address, uint256) external => transferSuccess(calledContract) expect bool ALL;
    
    // Alternativa mais simples: sempre retorna true
    // function _.transfer(address, uint256) external => ALWAYS(true);
    
    // Summary para IERC20.transferFrom se necessário
    function _.transferFrom(address, address, uint256) external => transferFromSuccess(calledContract) expect bool ALL;
    
    // Summary para IERC20.balanceOf se necessário
    function _.balanceOf(address) external => ghostTokenBalance[calledContract][to_mathint(args[0])] expect uint256 ALL;
    
    // ====================================
    // MÉTODOS ENVFREE DO COLLECTOR
    // ====================================
    
    function a.isFundsAdmin(address) external returns (bool) envfree;
    function ao.isFundsAdmin(address) external returns (bool) envfree;
    
    function a.getNextStreamId() external returns (uint256) envfree;
    function ao.getNextStreamId() external returns (uint256) envfree;
}

// ====================================
// GHOST VARIABLES PARA TOKENS
// ====================================

// Ghost para controlar sucesso de transfers
ghost mapping(address => bool) transferSuccess {
    init_state axiom forall address token. transferSuccess[token] == true;
}

// Ghost para controlar sucesso de transferFrom
ghost mapping(address => bool) transferFromSuccess {
    init_state axiom forall address token. transferFromSuccess[token] == true;
}

// Ghost para balances de tokens (token => user => balance)
ghost mapping(address => mapping(mathint => uint256)) ghostTokenBalance {
    init_state axiom forall address token. forall mathint user. 
        ghostTokenBalance[token][user] >= 0 && ghostTokenBalance[token][user] <= max_uint256;
}

// ====================================
// GHOST VARIABLES PARA ESTADO DO COLLECTOR
// ====================================

// Ghost para _nextStreamId
ghost uint256 ghost_a_nextStreamId {
    init_state axiom ghost_a_nextStreamId == 0;
}

ghost uint256 ghost_ao_nextStreamId {
    init_state axiom ghost_ao_nextStreamId == 0;
}

// Ghosts para _streams mapping - Contract A
ghost mapping(uint256 => address) ghost_a_streams_sender;
ghost mapping(uint256 => address) ghost_a_streams_recipient;
ghost mapping(uint256 => uint256) ghost_a_streams_deposit;
ghost mapping(uint256 => address) ghost_a_streams_tokenAddress;
ghost mapping(uint256 => uint256) ghost_a_streams_startTime;
ghost mapping(uint256 => uint256) ghost_a_streams_stopTime;
ghost mapping(uint256 => uint256) ghost_a_streams_remainingBalance;
ghost mapping(uint256 => uint256) ghost_a_streams_ratePerSecond;
ghost mapping(uint256 => bool) ghost_a_streams_isEntity;

// Ghosts para _streams mapping - Contract AO
ghost mapping(uint256 => address) ghost_ao_streams_sender;
ghost mapping(uint256 => address) ghost_ao_streams_recipient;
ghost mapping(uint256 => uint256) ghost_ao_streams_deposit;
ghost mapping(uint256 => address) ghost_ao_streams_tokenAddress;
ghost mapping(uint256 => uint256) ghost_ao_streams_startTime;
ghost mapping(uint256 => uint256) ghost_ao_streams_stopTime;
ghost mapping(uint256 => uint256) ghost_ao_streams_remainingBalance;
ghost mapping(uint256 => uint256) ghost_ao_streams_ratePerSecond;
ghost mapping(uint256 => bool) ghost_ao_streams_isEntity;

// ====================================
// HOOKS PARA CONTRACT A
// ====================================

// Hook para _nextStreamId
hook Sstore a._nextStreamId uint256 newValue (uint256 oldValue) {
    ghost_a_nextStreamId = newValue;
}

hook Sload uint256 val a._nextStreamId {
    require ghost_a_nextStreamId == val;
}

// Hooks para _streams
hook Sstore a._streams[KEY uint256 streamId].sender address newValue (address oldValue) {
    ghost_a_streams_sender[streamId] = newValue;
}

hook Sload address val a._streams[KEY uint256 streamId].sender {
    require ghost_a_streams_sender[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].recipient address newValue (address oldValue) {
    ghost_a_streams_recipient[streamId] = newValue;
}

hook Sload address val a._streams[KEY uint256 streamId].recipient {
    require ghost_a_streams_recipient[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].deposit uint256 newValue (uint256 oldValue) {
    ghost_a_streams_deposit[streamId] = newValue;
}

hook Sload uint256 val a._streams[KEY uint256 streamId].deposit {
    require ghost_a_streams_deposit[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].tokenAddress address newValue (address oldValue) {
    ghost_a_streams_tokenAddress[streamId] = newValue;
}

hook Sload address val a._streams[KEY uint256 streamId].tokenAddress {
    require ghost_a_streams_tokenAddress[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].startTime uint256 newValue (uint256 oldValue) {
    ghost_a_streams_startTime[streamId] = newValue;
}

hook Sload uint256 val a._streams[KEY uint256 streamId].startTime {
    require ghost_a_streams_startTime[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].stopTime uint256 newValue (uint256 oldValue) {
    ghost_a_streams_stopTime[streamId] = newValue;
}

hook Sload uint256 val a._streams[KEY uint256 streamId].stopTime {
    require ghost_a_streams_stopTime[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].remainingBalance uint256 newValue (uint256 oldValue) {
    ghost_a_streams_remainingBalance[streamId] = newValue;
}

hook Sload uint256 val a._streams[KEY uint256 streamId].remainingBalance {
    require ghost_a_streams_remainingBalance[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].ratePerSecond uint256 newValue (uint256 oldValue) {
    ghost_a_streams_ratePerSecond[streamId] = newValue;
}

hook Sload uint256 val a._streams[KEY uint256 streamId].ratePerSecond {
    require ghost_a_streams_ratePerSecond[streamId] == val;
}

hook Sstore a._streams[KEY uint256 streamId].isEntity bool newValue (bool oldValue) {
    ghost_a_streams_isEntity[streamId] = newValue;
}

hook Sload bool val a._streams[KEY uint256 streamId].isEntity {
    require ghost_a_streams_isEntity[streamId] == val;
}

// ====================================
// HOOKS PARA CONTRACT AO
// ====================================

// Hook para _nextStreamId
hook Sstore ao._nextStreamId uint256 newValue (uint256 oldValue) {
    ghost_ao_nextStreamId = newValue;
}

hook Sload uint256 val ao._nextStreamId {
    require ghost_ao_nextStreamId == val;
}

// Hooks para _streams
hook Sstore ao._streams[KEY uint256 streamId].sender address newValue (address oldValue) {
    ghost_ao_streams_sender[streamId] = newValue;
}

hook Sload address val ao._streams[KEY uint256 streamId].sender {
    require ghost_ao_streams_sender[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].recipient address newValue (address oldValue) {
    ghost_ao_streams_recipient[streamId] = newValue;
}

hook Sload address val ao._streams[KEY uint256 streamId].recipient {
    require ghost_ao_streams_recipient[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].deposit uint256 newValue (uint256 oldValue) {
    ghost_ao_streams_deposit[streamId] = newValue;
}

hook Sload uint256 val ao._streams[KEY uint256 streamId].deposit {
    require ghost_ao_streams_deposit[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].tokenAddress address newValue (address oldValue) {
    ghost_ao_streams_tokenAddress[streamId] = newValue;
}

hook Sload address val ao._streams[KEY uint256 streamId].tokenAddress {
    require ghost_ao_streams_tokenAddress[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].startTime uint256 newValue (uint256 oldValue) {
    ghost_ao_streams_startTime[streamId] = newValue;
}

hook Sload uint256 val ao._streams[KEY uint256 streamId].startTime {
    require ghost_ao_streams_startTime[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].stopTime uint256 newValue (uint256 oldValue) {
    ghost_ao_streams_stopTime[streamId] = newValue;
}

hook Sload uint256 val ao._streams[KEY uint256 streamId].stopTime {
    require ghost_ao_streams_stopTime[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].remainingBalance uint256 newValue (uint256 oldValue) {
    ghost_ao_streams_remainingBalance[streamId] = newValue;
}

hook Sload uint256 val ao._streams[KEY uint256 streamId].remainingBalance {
    require ghost_ao_streams_remainingBalance[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].ratePerSecond uint256 newValue (uint256 oldValue) {
    ghost_ao_streams_ratePerSecond[streamId] = newValue;
}

hook Sload uint256 val ao._streams[KEY uint256 streamId].ratePerSecond {
    require ghost_ao_streams_ratePerSecond[streamId] == val;
}

hook Sstore ao._streams[KEY uint256 streamId].isEntity bool newValue (bool oldValue) {
    ghost_ao_streams_isEntity[streamId] = newValue;
}

hook Sload bool val ao._streams[KEY uint256 streamId].isEntity {
    require ghost_ao_streams_isEntity[streamId] == val;
}

// ====================================
// INVARIANTE DE ACOPLAMENTO
// ====================================

definition couplingInv() returns bool =
    ghost_a_nextStreamId == ghost_ao_nextStreamId &&
    
    (forall uint256 streamId.
        ghost_a_streams_sender[streamId] == ghost_ao_streams_sender[streamId] &&
        ghost_a_streams_recipient[streamId] == ghost_ao_streams_recipient[streamId] &&
        ghost_a_streams_deposit[streamId] == ghost_ao_streams_deposit[streamId] &&
        ghost_a_streams_tokenAddress[streamId] == ghost_ao_streams_tokenAddress[streamId] &&
        ghost_a_streams_startTime[streamId] == ghost_ao_streams_startTime[streamId] &&
        ghost_a_streams_stopTime[streamId] == ghost_ao_streams_stopTime[streamId] &&
        ghost_a_streams_remainingBalance[streamId] == ghost_ao_streams_remainingBalance[streamId] &&
        ghost_a_streams_ratePerSecond[streamId] == ghost_ao_streams_ratePerSecond[streamId] &&
        ghost_a_streams_isEntity[streamId] == ghost_ao_streams_isEntity[streamId]
    );

// ====================================
// FUNÇÃO DE VERIFICAÇÃO GENÉRICA
// ====================================

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.block.number == eAo.block.number;
    
    require couplingInv();
    
    // Precondições para garantir comportamento consistente dos tokens
    require forall address token. 
        transferSuccess[token] == transferSuccess[token];
    require forall address token.
        transferFromSuccess[token] == transferFromSuccess[token];
    
    // Se você quiser garantir que transfers sempre tenham sucesso:
    // require forall address token. transferSuccess[token] == true;
    // require forall address token. transferFromSuccess[token] == true;
    
    a.f(eA, args);
    ao.g(eAo, args);
    
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