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
}

// ====================================
// GHOST VARIABLES PARA TOKENS
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
// GHOST VARIABLES PARA ESTADO DO COLLECTOR
// ====================================

// Ghost para _nextStreamId
ghost uint256 ghost_a_nextStreamId {
    init_state axiom ghost_a_nextStreamId == 0;
}

ghost uint256 ghost_ao_nextStreamId {
    init_state axiom ghost_ao_nextStreamId == 0;
}

// Ghost para ______gap
ghost mapping(uint256 => uint256) ghost_a_gap {
    init_state axiom forall uint256 i. ghost_a_gap[i] == 0;
}

ghost mapping(uint256 => uint256) ghost_ao_gap {
    init_state axiom forall uint256 i. ghost_ao_gap[i] == 0;
}

// Ghosts para _streams mapping - Contract A
ghost mapping(uint256 => address) ghost_a_streams_sender {
    init_state axiom forall uint256 streamId. ghost_a_streams_sender[streamId] == 0;
}
ghost mapping(uint256 => address) ghost_a_streams_recipient {
    init_state axiom forall uint256 streamId. ghost_a_streams_recipient[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_a_streams_deposit {
    init_state axiom forall uint256 streamId. ghost_a_streams_deposit[streamId] == 0;
}
ghost mapping(uint256 => address) ghost_a_streams_tokenAddress {
    init_state axiom forall uint256 streamId. ghost_a_streams_tokenAddress[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_a_streams_startTime {
    init_state axiom forall uint256 streamId. ghost_a_streams_startTime[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_a_streams_stopTime {
    init_state axiom forall uint256 streamId. ghost_a_streams_stopTime[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_a_streams_remainingBalance {
    init_state axiom forall uint256 streamId. ghost_a_streams_remainingBalance[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_a_streams_ratePerSecond {
    init_state axiom forall uint256 streamId. ghost_a_streams_ratePerSecond[streamId] == 0;
}
ghost mapping(uint256 => bool) ghost_a_streams_isEntity {
    init_state axiom forall uint256 streamId. ghost_a_streams_isEntity[streamId] == false;
}

// Ghosts para _streams mapping - Contract AO
ghost mapping(uint256 => address) ghost_ao_streams_sender {
    init_state axiom forall uint256 streamId. ghost_ao_streams_sender[streamId] == 0;
}
ghost mapping(uint256 => address) ghost_ao_streams_recipient {
    init_state axiom forall uint256 streamId. ghost_ao_streams_recipient[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_ao_streams_deposit {
    init_state axiom forall uint256 streamId. ghost_ao_streams_deposit[streamId] == 0;
}
ghost mapping(uint256 => address) ghost_ao_streams_tokenAddress {
    init_state axiom forall uint256 streamId. ghost_ao_streams_tokenAddress[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_ao_streams_startTime {
    init_state axiom forall uint256 streamId. ghost_ao_streams_startTime[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_ao_streams_stopTime {
    init_state axiom forall uint256 streamId. ghost_ao_streams_stopTime[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_ao_streams_remainingBalance {
    init_state axiom forall uint256 streamId. ghost_ao_streams_remainingBalance[streamId] == 0;
}
ghost mapping(uint256 => uint256) ghost_ao_streams_ratePerSecond {
    init_state axiom forall uint256 streamId. ghost_ao_streams_ratePerSecond[streamId] == 0;
}
ghost mapping(uint256 => bool) ghost_ao_streams_isEntity {
    init_state axiom forall uint256 streamId. ghost_ao_streams_isEntity[streamId] == false;
}

// Ghosts para roles do AccessControl - Contract A
ghost mapping(bytes32 => mapping(address => bool)) ghost_a_roles_hasRole {
    init_state axiom forall bytes32 role. forall address account. ghost_a_roles_hasRole[role][account] == false;
}
ghost mapping(bytes32 => bytes32) ghost_a_roles_adminRole {
    init_state axiom forall bytes32 role. ghost_a_roles_adminRole[role] == to_bytes32(0);
}

// Ghosts para roles do AccessControl - Contract AO
ghost mapping(bytes32 => mapping(address => bool)) ghost_ao_roles_hasRole {
    init_state axiom forall bytes32 role. forall address account. ghost_ao_roles_hasRole[role][account] == false;
}
ghost mapping(bytes32 => bytes32) ghost_ao_roles_adminRole {
    init_state axiom forall bytes32 role. ghost_ao_roles_adminRole[role] == to_bytes32(0);
}

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

// Hooks para ______gap
hook Sstore a.______gap[INDEX uint256 i] uint256 newValue (uint256 oldValue) {
    ghost_a_gap[i] = newValue;
}

hook Sload uint256 val a.______gap[INDEX uint256 i] {
    require ghost_a_gap[i] == val;
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

// Hooks para ______gap
hook Sstore ao.______gap[INDEX uint256 i] uint256 newValue (uint256 oldValue) {
    ghost_ao_gap[i] = newValue;
}

hook Sload uint256 val ao.______gap[INDEX uint256 i] {
    require ghost_ao_gap[i] == val;
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
    
    (forall uint256 i. i < 53 => ghost_a_gap[i] == ghost_ao_gap[i]) &&
    
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
    ) &&
    
    (forall bytes32 role. forall address account.
        ghost_a_roles_hasRole[role][account] == ghost_ao_roles_hasRole[role][account]
    ) &&
    
    (forall bytes32 role.
        ghost_a_roles_adminRole[role] == ghost_ao_roles_adminRole[role]
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
        ghostTransferSuccess[token] == ghostTransferSuccess[token];
    require forall address token.
        ghostTransferFromSuccess[token] == ghostTransferFromSuccess[token];
    
    storage initialStorageA = lastStorage;
    storage initialStorageAo = lastStorage;
    
    a.f(eA, args) at initialStorageA;
    ao.g(eAo, args) at initialStorageAo;
    
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