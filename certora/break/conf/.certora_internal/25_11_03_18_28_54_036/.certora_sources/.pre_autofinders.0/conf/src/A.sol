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
        uint256 taskId = taskCount++;
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
        uint256 result = type(uint256).max;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            Task memory task = tasks[taskId];
            
            if (task.assignee == user && !task.isCompleted) {
                result = taskId;
                break; // Para no primeiro encontrado
            }
        }
        
        return result;
    }
    
    function findHighPriorityTask(uint256 minPriority) external view returns (uint256) {
        uint256 result = type(uint256).max;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            Task memory task = tasks[taskId];
            
            if (!task.isCompleted && task.priority >= minPriority) {
                result = taskId;
                break; // Para no primeiro de alta prioridade
            }
        }
        
        return result;
    }
    
    function processTasksUntilCondition(uint256 maxToProcess) external returns (uint256) {
        uint256 processed = 0;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            
            if (tasks[taskId].isCompleted) {
                continue;
            }
            
            // Processa tarefa (simulado)
            tasks[taskId].priority++;
            processed++;
            
            if (processed >= maxToProcess) {
                break; // Para após processar o máximo
            }
        }
        
        return processed;
    }
    
    function searchTaskByPriority(uint256 targetPriority) external view returns (bool, uint256) {
        bool found = false;
        uint256 foundId = 0;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            
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
        Task memory task = tasks[taskId];
        return (task.id, task.assignee, task.priority, task.isCompleted);
    }
    
    function getTaskIdsLength() external view returns (uint256) {
        return taskIds.length;
    }
}