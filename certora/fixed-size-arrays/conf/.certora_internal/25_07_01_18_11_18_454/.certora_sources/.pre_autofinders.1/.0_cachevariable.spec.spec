using A as a;
using Ao as ao;

methods {
    function a.getData() external returns (uint256) envfree;
    function ao.getData() external returns (uint256) envfree;

    function a.getUsersLength() external returns (uint256) envfree;
    function ao.getUsersLength() external returns (uint256) envfree;

    function a.getTotalBalance() external returns (uint256) envfree;
    function ao.getTotalBalance() external returns (uint256) envfree;

    function a.getActiveCount() external returns (uint256) envfree;
    function ao.getActiveCount() external returns (uint256) envfree;

    function a.addUser(string memory _name, uint _balance, bool _active) external;
    function ao.addUser(string memory _name, uint _balance, bool _active) external;
}

definition couplingInv() returns bool =
    a.getUsersLength() == ao.getUsersLength() &&
    a.getTotalBalance() == ao.getTotalBalance() &&
    a.getActiveCount() == ao.getActiveCount() &&
    a.getData() == ao.getData();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfProcessUsers(method f, method g)
    filtered {
        f -> f.selector == sig:a.processUsers().selector,
        g -> g.selector == sig:ao.processUsers().selector
    } {
    gasOptimizationCorrectness(f, g);
}
