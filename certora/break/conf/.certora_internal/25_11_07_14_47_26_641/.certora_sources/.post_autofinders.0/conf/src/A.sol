// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
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
    
    function findFirstIncompleteTask(address user) external view returns (uint256) {
        uint256 result = type(uint256).max;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,result)}
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,taskId)}
            Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010008,0)}
            
            if (task.assignee == user && !task.isCompleted) {
                result = taskId;
                break; // Para no primeiro encontrado
            }
        }
        
        return result;
    }
    
    function findHighPriorityTask(uint256 minPriority) external view returns (uint256) {
        uint256 result = type(uint256).max;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,result)}
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,taskId)}
            Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000a,0)}
            
            if (!task.isCompleted && task.priority >= minPriority) {
                result = taskId;
                break; // Para no primeiro de alta prioridade
            }
        }
        
        return result;
    }
    
    function searchTaskByPriority(uint256 targetPriority) external view returns (bool, uint256) {
        bool found = false;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,found)}
        uint256 foundId = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,foundId)}
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,taskId)}
            
            if (tasks[taskId].priority == targetPriority && !tasks[taskId].isCompleted) {
                found = true;
                foundId = taskId;
                break;
            }
        }
        
        return (found, foundId);
    }
    
    // View functions
    function getTaskData(uint256 taskId) external view returns (uint256, address, uint256, bool) {
        Task memory task = tasks[taskId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010006,0)}
        return (task.id, task.assignee, task.priority, task.isCompleted);
    }
    
    function getTaskIdsLength() external view returns (uint256) {
        return taskIds.length;
    }
}