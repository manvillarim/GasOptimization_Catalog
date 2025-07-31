// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Contract A_corrected - Dynamic Arrays with Equivalent Logic
 * @dev This contract is corrected to be functionally equivalent to Ao,
 * implementing the same robust algorithms but on dynamic arrays.
 */
contract A {
    uint256[] public balances;
    address[] public users;
    string[] public names;
    bool[] public permissions;
    bytes32[] public hashes;

    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
    }
    
    Transaction[] public transactions;
    

    mapping(address => uint256) public userIndex;
    mapping(address => bool) public userExists; 

    function addBalances(uint256[] memory newBalances) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, newBalances) }
        for (uint256 i = 0; i < newBalances.length; i++) {
            balances.push(newBalances[i]);
        }
    }
    
    function addUser(address user, string memory name, bool permission) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00046002, permission) }

        require(!userExists[user], "User already exists");

        users.push(user);
        names.push(name);
        permissions.push(permission);
        
        userIndex[user] = users.length - 1;
        userExists[user] = true; 
    }
    
    /**
     * Remove user using the robust "swap-and-pop" algorithm to match Ao's logic.
     * Signature changed from (uint256 index) to (address user).
     */
    function removeUser(address user) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, user) }
        require(userExists[user], "User does not exist");
        
        uint256 indexToRemove = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,indexToRemove)}
        uint256 lastIndex = users.length - 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,lastIndex)}
        
        // Se o usuário a ser removido não for o último...
        if (indexToRemove != lastIndex) {
            // Pega o último usuário
            address lastUser = users[lastIndex];
            
            // Move o último usuário para a posição do que foi removido
            users[indexToRemove] = lastUser;
            names[indexToRemove] = names[lastIndex];
            permissions[indexToRemove] = permissions[lastIndex];
            
            // Atualiza o índice do usuário que foi movido
            userIndex[lastUser] = indexToRemove;
        }
        
        // Remove o último elemento do array (que agora é um duplicado ou o alvo original)
        users.pop();
        names.pop();
        permissions.pop();
        
        // Limpa os dados do usuário removido
        delete userIndex[user];
        userExists[user] = false;
    }
    
    function addTransaction(address from, address to, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070000, 1037618708487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00070005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00076002, amount) }
        transactions.push(Transaction({
            from: from,
            to: to,
            amount: amount,
            timestamp: block.timestamp
        }));
    }

    // A função addMultipleTransactions permanece a mesma, pois sua lógica já era compatível.
    function addMultipleTransactions(
        address[] memory fromAddresses,
        address[] memory toAddresses,
        uint256[] memory amounts
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006002, amounts) }
        require(
            fromAddresses.length == toAddresses.length && 
            toAddresses.length == amounts.length,
            "Array lengths must match"
        );
        
        for (uint256 i = 0; i < fromAddresses.length; i++) {
            addTransaction(fromAddresses[i], toAddresses[i], amounts[i]);
        }
    }

    function clearAllData() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060000, 1037618708486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00060004, 0) }
        delete balances;
        delete users;
        delete names;
        delete permissions;
        delete hashes;
        delete transactions;
        // Mapeamentos não podem ser deletados, mas a lógica de remoção individual
        // garante que userExists será 'false' para usuários removidos.
        // Em um clearAll, a lógica do contrato deve garantir que
        // os mapeamentos não sejam reutilizados incorretamente.
    }
    
    // Funções `view` permanecem as mesmas
    function getAllBalances() public view returns (uint256[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        return balances;
    }
    
    function getUserInfo(address user) public view returns (string memory name, bool permission) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036000, user) }
        require(userExists[user], "User not found"); // Lógica agora mais robusta
        uint256 index = userIndex[user];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,index)}
        return (names[index], permissions[index]);
    }
}