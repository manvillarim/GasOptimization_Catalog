using A as a;
using Ao as ao;

methods {
    // Funções de modificação de estado
    function a.processArrays() external;
    function ao.processArrays() external;
    function a.addUserData(uint _balance, bool _active) external;
    function ao.addUserData(uint _balance, bool _active) external;

    // Getters para a invariante, permitindo acesso direto às variáveis de estado dos arrays
    // Certora acessa a.balances[i], a.actives[i], a.transactions[i][j] diretamente
    function a.getLength() external returns (uint256) envfree;
    function ao.getLength() external returns (uint256) envfree;
    // Não precisamos declarar explicitamente getBalanceAt, getActiveAt, getTransactionAt
    // porque o prover pode acessar os arrays públicos diretamente via a.balances[i] etc.
}

// Invariante de acoplamento atualizada para múltiplos arrays
definition couplingInv() returns bool =
    // 1. Todos os arrays têm o mesmo comprimento em ambos os contratos
    a.balances.length == ao.balances.length &&
    a.actives.length == ao.actives.length &&
    a.transactions.length == ao.transactions.length &&

    (
        // 2. Se os arrays estiverem vazios, a condição de elementos é trivialmente verdadeira
        a.balances.length == 0 ||
        // 3. Para cada índice 'i', os elementos correspondentes em cada array principal são iguais
        (forall uint256 i. (i < a.balances.length =>
            a.balances[i] == ao.balances[i] && // Compara balances
            a.actives[i] == ao.actives[i] &&   // Compara actives
            // Para o array aninhado 'transactions[i]', verificamos o comprimento e depois cada elemento
            a.transactions[i].length == ao.transactions[i].length &&
            (forall uint256 j. (j < a.transactions[i].length =>
                a.transactions[i][j] == ao.transactions[i][j] // Compara elementos de transactions
            ))
        ))
    );

function arrayOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

    // Pré-condição: ambientes idênticos e invariante verdadeira
    require eA == eAo && couplingInv();

    // Executa as funções em ambos os contratos
    a.f(eA, args);
    ao.g(eAo, args);

    // Pós-condição: invariante ainda verdadeira após a execução
    assert couplingInv();
}

// Regras para as funções que modificam o estado
rule arrayOptimizedCorrectnessOfProcessArrays(method f, method g)
    filtered {
        f -> f.selector == sig:a.processArrays().selector,
        g -> g.selector == sig:ao.processArrays().selector
    } {
    arrayOptimizationCorrectness(f, g);
}

rule arrayOptimizedCorrectnessOfAddUserData(method f, method g)
    filtered {
        f -> f.selector == sig:a.addUserData(uint256,bool).selector,
        g -> g.selector == sig:ao.addUserData(uint256,bool).selector
    } {
    arrayOptimizationCorrectness(f, g);
}