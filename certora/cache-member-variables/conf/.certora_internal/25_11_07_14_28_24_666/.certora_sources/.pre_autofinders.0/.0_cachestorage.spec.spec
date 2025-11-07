using A as a;
using Ao as ao;

methods {

    function a.processArrays() external;
    function ao.processArrays() external;
    function a.addUserData(uint _balance, bool _active) external;
    function ao.addUserData(uint _balance, bool _active) external;
    function a.getLength() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
}


definition couplingInv() returns bool =

    a.balances.length == ao.balances.length &&
    a.actives.length == ao.actives.length &&
    a.transactions.length == ao.transactions.length &&

    (

        a.balances.length == 0 ||
        (forall uint256 i. (i < a.balances.length =>
            a.balances[i] == ao.balances[i] && 
            a.actives[i] == ao.actives[i] &&  
            a.transactions[i].length == ao.transactions[i].length &&
            (forall uint256 j. (j < a.transactions[i].length =>
                a.transactions[i][j] == ao.transactions[i][j] 
            ))
        ))
    );

function arrayOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();

    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;

    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule arrayOptimizedCorrectnessOfProcessArrays(method f, method g)
    filtered {
        f -> f.selector == sig:a.processArrays().selector,
        g -> g.selector == sig:ao.processArrays().selector
    } {
    arrayOptimizationCorrectness(f, g);
}
