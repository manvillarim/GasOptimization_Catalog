using A as a;
using Ao as ao;

methods {
    function a.addBalances(uint256[]) external;
    function ao.addBalances(uint256[]) external;
    function a.addUser(address, string, bool) external;
    function ao.addUser(address, string, bool) external;
    function a.removeUser(address) external;
    function ao.removeUser(address) external;
    function a.addTransaction(address, address, uint256) external;
    function ao.addTransaction(address, address, uint256) external;
    function a.clearAllData() external;
    function ao.clearAllData() external;
    function a.getAllBalances() external returns (uint256[]) envfree;
    function ao.getAllBalances() external returns (uint256[]) envfree;
    function a.getUserInfo(address) external returns (string, bool) envfree;
    function ao.getUserInfo(address) external returns (string, bool) envfree;
}

definition couplingInv() returns bool =
    a.balances.length == ao.balancesLength &&
    a.users.length == ao.usersLength &&
    a.transactions.length == ao.transactionsLength &&
    (forall address u. a.userExists[u] == ao.userExists[u] &&
     a.userIndex[u] == ao.userIndex[u]) &&
    (forall uint i. (i < a.balances.length => a.balances[i] == ao.balances[i])) &&
    (forall uint i. (i < a.users.length =>
        a.users[i] == ao.users[i] &&
        a.permissions[i] == ao.permissions[i])) &&
    (forall uint i. (i < a.transactions.length =>
        a.transactions[i].from == ao.transactions[i].from &&
        a.transactions[i].to == ao.transactions[i].to &&
        a.transactions[i].amount == ao.transactions[i].amount));

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.block.timestamp == eAo.block.timestamp;
    require eA.msg.sender == eAo.msg.sender;
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule correctnessOfStateChangingFunctions(method f, method g)
filtered {
    f -> f.selector != sig:a.getAllBalances().selector &&
         f.selector != sig:a.getUserInfo(address).selector,
    g -> g.selector == f.selector
} {
    gasOptimizationCorrectness(f, g);
}

rule correctnessOfViewFunctions(method f, method g)
filtered {
    f -> f.selector == sig:a.getAllBalances().selector ||
         f.selector == sig:a.getUserInfo(address).selector,
    g -> g.selector == f.selector
} {
    env e;
    calldataarg args;
    
    require couplingInv();
    
    if (f.selector == sig:a.getAllBalances().selector) {
        uint256[] retA = a.getAllBalances(e);
        uint256[] retAo = ao.getAllBalances(e);
        assert retA.length == retAo.length;
        assert forall uint i. (i < retA.length => retA[i] == retAo[i]);
    } else if (f.selector == sig:a.getUserInfo(address).selector) {
        address user;
        string nameA; bool permA = a.getUserInfo(e, user);
        string nameAo; bool permAo = ao.getUserInfo(e, user);
        assert permA == permAo, "Permission values do not match";
    }
}