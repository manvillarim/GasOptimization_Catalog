using A as a;
using Ao as ao;

methods {
    function mint(address to, uint amount) external;
    function getTokenInfo() external returns(address, uint, uint, string, string, uint8, bytes32) envfree;
    function validateMerkleProof(bytes32[] proof, bytes32 leaf) external returns(bool) envfree;
    function calculateFees(uint amount) external returns(uint) envfree;
    function isOwner() external returns(bool) envfree;
}


definition couplingInv() returns bool =
    a.owner == ao.OWNER &&
    a.deploymentBlock == ao.DEPLOYMENT_BLOCK &&
    a.maxSupply == ao.MAX_SUPPLY &&
    a.decimals == ao.DECIMALS &&
    a.merkleRoot == ao.MERKLE_ROOT &&
    a.tokenName == ao.tokenName &&
    a.tokenSymbol == ao.tokenSymbol &&
    a.totalSupply == ao.totalSupply &&
    (forall address k. a.balances[k] == ao.balances[k]);


function gasOptimizationCorrectness(method f, method g) {
    env e;
    calldataarg args;

    require couplingInv();

    bytes f_out = f(e, args);
    bytes g_out = g(e, args);

    assert f_out == g_out;
    assert couplingInv();
}


rule gasOptimizedCorrectnessOfMint(method f, method g)
    filtered {
        f -> f.selector == sig:a.mint(address,uint).selector,
        g -> g.selector == sig:ao.mint(address,uint).selector
    }
{
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetTokenInfo(method f, method g)
    filtered {
        f -> f.selector == sig:a.getTokenInfo().selector,
        g -> g.selector == sig:ao.getTokenInfo().selector
    }
{
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfValidateMerkleProof(method f, method g)
    filtered {
        f -> f.selector == sig:a.validateMerkleProof(bytes32[],bytes32).selector,
        g -> g.selector == sig:ao.validateMerkleProof(bytes32[],bytes32).selector
    }
{
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateFees(method f, method g)
    filtered {
        f -> f.selector == sig:a.calculateFees(uint).selector,
        g -> g.selector == sig:ao.calculateFees(uint).selector
    }
{
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfIsOwner(method f, method g)
    filtered {
        f -> f.selector == sig:a.isOwner().selector,
        g -> g.selector == sig:ao.isOwner().selector
    }
{
    gasOptimizationCorrectness(f, g);
}