using A as a;
using Ao as ao;

methods {
    
    function a.tasks(uint256) external returns (uint256, address, uint256, bool) envfree;
    function a.taskIds(uint256) external returns (uint256) envfree;
    function a.taskCount() external returns (uint256) envfree;
    function a.completedCount() external returns (uint256) envfree;
    function a.userTaskCount(address) external returns (uint256) envfree;
    function a.userCompletedCount(address) external returns (uint256) envfree;
    function a.getTaskIdsLength() external returns (uint256) envfree;
    
    function ao.tasks(uint256) external returns (uint256, address, uint256, bool) envfree;
    function ao.taskIds(uint256) external returns (uint256) envfree;
    function ao.taskCount() external returns (uint256) envfree;
    function ao.completedCount() external returns (uint256) envfree;
    function ao.userTaskCount(address) external returns (uint256) envfree;
    function ao.userCompletedCount(address) external returns (uint256) envfree;
    function ao.getTaskIdsLength() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.taskCount == ao.taskCount &&
    a.completedCount == ao.completedCount &&
    a.taskIds.length == ao.taskIds.length &&
    (forall uint256 i. (i < a.taskIds.length => 
        a.taskIds[i] == ao.taskIds[i]
    )) &&
    (forall uint256 taskId. (taskId < a.taskCount => (
        a.tasks[taskId].id == ao.tasks[taskId].id &&
        a.tasks[taskId].assignee == ao.tasks[taskId].assignee &&
        a.tasks[taskId].priority == ao.tasks[taskId].priority &&
        a.tasks[taskId].isCompleted == ao.tasks[taskId].isCompleted
    ))) &&
    (forall address user. (
        a.userTaskCount[user] == ao.userTaskCount[user] &&
        a.userCompletedCount[user] == ao.userCompletedCount[user]
    ));

// Generic correctness function for all method pairs
function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

// Rule for createTask
rule gasOptimizedCorrectnessOf_createTask(method f, method g)
filtered {
    f -> f.selector == sig:a.createTask(address,uint256).selector,
    g -> g.selector == sig:ao.createTask(address,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for completeTask
rule gasOptimizedCorrectnessOf_completeTask(method f, method g)
filtered {
    f -> f.selector == sig:a.completeTask(uint256).selector,
    g -> g.selector == sig:ao.completeTask(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for findFirstIncompleteTask (main optimization target)
rule gasOptimizedCorrectnessOf_findFirstIncompleteTask(method f, method g)
filtered {
    f -> f.selector == sig:a.findFirstIncompleteTask(address).selector,
    g -> g.selector == sig:ao.findFirstIncompleteTask(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for findHighPriorityTask (main optimization target)
rule gasOptimizedCorrectnessOf_findHighPriorityTask(method f, method g)
filtered {
    f -> f.selector == sig:a.findHighPriorityTask(uint256).selector,
    g -> g.selector == sig:ao.findHighPriorityTask(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for processTasksUntilCondition (main optimization target)
rule gasOptimizedCorrectnessOf_processTasksUntilCondition(method f, method g)
filtered {
    f -> f.selector == sig:a.processTasksUntilCondition(uint256).selector,
    g -> g.selector == sig:ao.processTasksUntilCondition(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

// Rule for searchTaskByPriority (main optimization target)
rule gasOptimizedCorrectnessOf_searchTaskByPriority(method f, method g)
filtered {
    f -> f.selector == sig:a.searchTaskByPriority(uint256).selector,
    g -> g.selector == sig:ao.searchTaskByPriority(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}