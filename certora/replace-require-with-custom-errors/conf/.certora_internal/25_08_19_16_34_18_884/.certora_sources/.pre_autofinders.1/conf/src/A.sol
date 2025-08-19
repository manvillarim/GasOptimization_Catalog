// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    // State variables
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public minTransferAmount;
    uint256 public maxTransferAmount;
    bool public paused;
    
    // Staking related
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakingTimestamps;
    uint256 public minStakeAmount;
    uint256 public stakingDuration;
    
    // Access control
    mapping(address => bool) public admins;
    mapping(address => bool) public blacklisted;
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    
    constructor() {
        owner = msg.sender;
        maxSupply = 1000000 * 10**18;
        minTransferAmount = 1;
        maxTransferAmount = 10000 * 10**18;
        minStakeAmount = 100 * 10**18;
        stakingDuration = 30 days;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner, "Only admin or owner can call this function");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    // Transfer function with multiple require statements
    function transfer(address to, uint256 amount) external whenNotPaused returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(to != msg.sender, "Cannot transfer to yourself");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(amount >= minTransferAmount, "Transfer amount below minimum limit");
        require(amount <= maxTransferAmount, "Transfer amount exceeds maximum limit");
        require(balances[msg.sender] >= amount, "Insufficient balance for transfer");
        require(!blacklisted[msg.sender], "Sender is blacklisted");
        require(!blacklisted[to], "Recipient is blacklisted");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    // Approve function with validation
    function approve(address spender, uint256 amount) external whenNotPaused returns (bool) {
        require(spender != address(0), "Cannot approve zero address");
        require(spender != msg.sender, "Cannot approve yourself");
        require(amount <= balances[msg.sender], "Approval amount exceeds balance");
        require(!blacklisted[msg.sender], "Sender is blacklisted");
        require(!blacklisted[spender], "Spender is blacklisted");
        
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    // Transfer from with allowance checks
    function transferFrom(address from, address to, uint256 amount) external whenNotPaused returns (bool) {
        require(from != address(0), "Cannot transfer from zero address");
        require(to != address(0), "Cannot transfer to zero address");
        require(from != to, "Cannot transfer to same address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(amount >= minTransferAmount, "Transfer amount below minimum limit");
        require(amount <= maxTransferAmount, "Transfer amount exceeds maximum limit");
        require(balances[from] >= amount, "Insufficient balance for transfer");
        require(allowances[from][msg.sender] >= amount, "Insufficient allowance for transfer");
        require(!blacklisted[from], "From address is blacklisted");
        require(!blacklisted[to], "To address is blacklisted");
        require(!blacklisted[msg.sender], "Caller is blacklisted");
        
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    // Minting function with supply checks
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Mint amount must be greater than zero");
        require(totalSupply + amount <= maxSupply, "Minting would exceed max supply");
        require(!blacklisted[to], "Cannot mint to blacklisted address");
        
        balances[to] += amount;
        totalSupply += amount;
        
        emit Transfer(address(0), to, amount);
    }
    
    // Burning function
    function burn(uint256 amount) external whenNotPaused {
        require(amount > 0, "Burn amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance to burn");
        require(!blacklisted[msg.sender], "Blacklisted address cannot burn tokens");
        
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        
        emit Transfer(msg.sender, address(0), amount);
    }
    
    // Staking function
    function stake(uint256 amount) external whenNotPaused {
        require(amount >= minStakeAmount, "Stake amount below minimum requirement");
        require(balances[msg.sender] >= amount, "Insufficient balance for staking");
        require(stakedBalances[msg.sender] == 0, "Already have an active stake");
        require(!blacklisted[msg.sender], "Blacklisted address cannot stake");
        
        balances[msg.sender] -= amount;
        stakedBalances[msg.sender] = amount;
        stakingTimestamps[msg.sender] = block.timestamp;
        
        emit Staked(msg.sender, amount);
    }
    
    // Unstaking function
    function unstake() external whenNotPaused {
        require(stakedBalances[msg.sender] > 0, "No active stake found");
        require(
            block.timestamp >= stakingTimestamps[msg.sender] + stakingDuration,
            "Staking period not yet completed"
        );
        require(!blacklisted[msg.sender], "Blacklisted address cannot unstake");
        
        uint256 amount = stakedBalances[msg.sender];
        stakedBalances[msg.sender] = 0;
        stakingTimestamps[msg.sender] = 0;
        balances[msg.sender] += amount;
        
        emit Unstaked(msg.sender, amount);
    }
    
    // Admin management
    function addAdmin(address admin) external onlyOwner {
        require(admin != address(0), "Cannot add zero address as admin");
        require(admin != owner, "Owner is already an admin");
        require(!admins[admin], "Address is already an admin");
        require(!blacklisted[admin], "Cannot add blacklisted address as admin");
        
        admins[admin] = true;
        emit AdminAdded(admin);
    }
    
    function removeAdmin(address admin) external onlyOwner {
        require(admin != address(0), "Cannot remove zero address as admin");
        require(admins[admin], "Address is not an admin");
        
        admins[admin] = false;
        emit AdminRemoved(admin);
    }
    
    // Blacklist management
    function blacklistAddress(address user) external onlyAdmin {
        require(user != address(0), "Cannot blacklist zero address");
        require(user != owner, "Cannot blacklist owner");
        require(!admins[user], "Cannot blacklist admin");
        require(!blacklisted[user], "Address is already blacklisted");
        
        blacklisted[user] = true;
    }
    
    function unblacklistAddress(address user) external onlyAdmin {
        require(user != address(0), "Cannot unblacklist zero address");
        require(blacklisted[user], "Address is not blacklisted");
        
        blacklisted[user] = false;
    }
    
    // Contract management
    function pause() external onlyOwner {
        require(!paused, "Contract is already paused");
        paused = true;
    }
    
    function unpause() external onlyOwner {
        require(paused, "Contract is not paused");
        paused = false;
    }
    
    function updateTransferLimits(uint256 min, uint256 max) external onlyOwner {
        require(min > 0, "Minimum transfer amount must be greater than zero");
        require(max > min, "Maximum must be greater than minimum");
        require(max <= maxSupply, "Maximum transfer cannot exceed max supply");
        
        minTransferAmount = min;
        maxTransferAmount = max;
    }
    
    function updateStakingParams(uint256 minAmount, uint256 duration) external onlyOwner {
        require(minAmount > 0, "Minimum stake amount must be greater than zero");
        require(duration >= 1 days, "Staking duration must be at least 1 day");
        require(duration <= 365 days, "Staking duration cannot exceed 1 year");
        
        minStakeAmount = minAmount;
        stakingDuration = duration;
    }
    
    // Emergency withdrawal (only owner)
    function emergencyWithdraw(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot withdraw to zero address");
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[address(this)] >= amount, "Insufficient contract balance");
        
        balances[address(this)] -= amount;
        balances[to] += amount;
        
        emit Transfer(address(this), to, amount);
    }
}