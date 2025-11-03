// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    struct Task {
        uint256 id;
        address assignee;
        uint256 priority;
        bool isCompleted;
    }
    
    mapping(uint256 => Task) public tasks;
    uint256[] public taskIds;
    uint256 public taskCount;
    uint256 public completedCount;
    
    mapping(address => uint256) public userTaskCount;
    mapping(address => uint256) public userCompletedCount;
    
    function createTask(address assignee, uint256 priority) external {
        uint256 taskId = taskCount++;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,taskId)}
        tasks[taskId] = Task(taskId, assignee, priority, false);
        taskIds.push(taskId);
        userTaskCount[assignee]++;
    }
    
    function completeTask(uint256 taskId) external {
        require(!tasks[taskId].isCompleted, "Already completed");
        tasks[taskId].isCompleted = true;
        completedCount++;
        userCompletedCount[tasks[taskId].assignee]++;
    }
    
    function findFirstIncompleteTask(address user) external view returns (uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,taskId)}
            Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010005,0)}
            
            if (task.assignee == user && !task.isCompleted) {
                return taskId; // Early return ao invés de break
            }
        }
        
        return type(uint256).max; // Valor padrão após o loop
    }
    
    function findHighPriorityTask(uint256 minPriority) external view returns (uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,taskId)}
            Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010007,0)}
            
            if (!task.isCompleted && task.priority >= minPriority) {
                return taskId; // Early return
            }
        }
        
        return type(uint256).max;
    }
    
    function processTasksUntilCondition(uint256 maxToProcess) external returns (uint256) {
        uint256 processed = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,processed)}
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,taskId)}
            
            if (tasks[taskId].isCompleted) {
                continue;
            }
            
            // Processa tarefa (simulado)
            tasks[taskId].priority++;
            processed++;
            
            if (processed >= maxToProcess) {
                return processed; // Early return ao invés de break
            }
        }
        
        return processed; // Retorna após loop completo
    }
    
    function searchTaskByPriority(uint256 targetPriority) external view returns (bool, uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,taskId)}
            
            if (tasks[taskId].priority == targetPriority && !tasks[taskId].isCompleted) {
                return (true, taskId); // Early return
            }
        }
        
        return (false, 0); // Não encontrado
    }
    
    // View functions
    function getTaskData(uint256 taskId) external view returns (uint256, address, uint256, bool) {
        Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010003,0)}
        return (task.id, task.assignee, task.priority, task.isCompleted);
    }
    
    function getTaskIdsLength() external view returns (uint256) {
        return taskIds.length;
    }
}