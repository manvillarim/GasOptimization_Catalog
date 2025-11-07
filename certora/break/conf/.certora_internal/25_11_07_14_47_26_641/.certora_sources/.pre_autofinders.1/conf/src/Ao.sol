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
        uint256 taskId = taskCount++;
        tasks[taskId] = Task(taskId, assignee, priority, false);
        taskIds.push(taskId);
        userTaskCount[assignee]++;
    }
    
    function findFirstIncompleteTask(address user) external view returns (uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            Task memory task = tasks[taskId];
            
            if (task.assignee == user && !task.isCompleted) {
                return taskId; // Early return ao invés de break
            }
        }
        
        return type(uint256).max; // Valor padrão após o loop
    }
    
    function findHighPriorityTask(uint256 minPriority) external view returns (uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            Task memory task = tasks[taskId];
            
            if (!task.isCompleted && task.priority >= minPriority) {
                return taskId; // Early return
            }
        }
        
        return type(uint256).max;
    }
    
    function searchTaskByPriority(uint256 targetPriority) external view returns (bool, uint256) {
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            
            if (tasks[taskId].priority == targetPriority && !tasks[taskId].isCompleted) {
                return (true, taskId); // Early return
            }
        }
        
        return (false, 0); // Não encontrado
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