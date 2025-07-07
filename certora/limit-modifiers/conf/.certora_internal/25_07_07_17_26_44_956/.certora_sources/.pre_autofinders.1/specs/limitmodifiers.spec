using A as a;
using Ao as ao;

methods {

}

// Invariante de acoplamento: define a relação esperada entre os estados de A e Ao
definition couplingInv() returns bool =
    a.owner == ao.owner &&
    a.paused == ao.paused &&
    (forall address addr. (a.authorized(addr) == ao.authorized(addr))) && // Verifica o mapeamento 'authorized'
    a.total == ao.total &&
    a.count == ao.count &&
    a.numbers.length == ao.numbers.length &&
    (
        a.numbers.length == 0 ||
        (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i]))
    );

// Função genérica para verificar a correção da otimização
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    // Os ambientes e o estado inicial devem ser os mesmos e satisfazer a invariante de acoplamento
    require eA == eAo && couplingInv();

    // Executa os métodos em A e Ao
    a.f(eA, args);
    ao.g(eAo, args);

    // Após a execução, a invariante de acoplamento deve ser mantida
    assert couplingInv();
}

// Regra para 'criticalFunction'
rule gasOptimizedCorrectnessOfCriticalFunction(method f, method g)
    filtered {
        f -> f.selector == sig:a.criticalFunction(address).selector,
        g -> g.selector == sig:ao.criticalFunction(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

// Regra para 'authorize'
rule gasOptimizedCorrectnessOfAuthorize(method f, method g)
    filtered {
        f -> f.selector == sig:a.authorize(address).selector,
        g -> g.selector == sig:ao.authorize(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

// Regra para 'unauthorize'
rule gasOptimizedCorrectnessOfUnauthorize(method f, method g)
    filtered {
        f -> f.selector == sig:a.unauthorize(address).selector,
        g -> g.selector == sig:ao.unauthorize(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

// Regra para 'setPaused'
rule gasOptimizedCorrectnessOfSetPaused(method f, method g)
    filtered {
        f -> f.selector == sig:a.setPaused(bool).selector,
        g -> g.selector == sig:ao.setPaused(bool).selector
    } {
    gasOptimizationCorrectness(f, g);
}

// Regras para os métodos adicionados para o CVL
rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g)
    filtered {
        f -> f.selector == sig:a.processNumbers(uint).selector,
        g -> g.selector == sig:ao.processNumbers(uint).selector
    } {
    gasOptimizationCorrectness(f, g);
}