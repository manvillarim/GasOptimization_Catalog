// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    // Custom errors definition - much more gas efficient than require strings
    error ZeroAddress();
    error SelfTransfer();
    error ZeroAmount();
    error AmountBelowMinimum(uint256 amount, uint256 minimum);
    error AmountExceedsMaximum(uint256 amount, uint256 maximum);
    error InsufficientBalance(uint256 available, uint256 required);
    error InsufficientAllowance(uint256 available, uint256 required);
    error SenderBlacklisted(address sender);
    error RecipientBlacklisted(address recipient);
    error CallerBlacklisted(address caller);
    error ContractPaused();
    error OnlyOwner(address caller);
    error OnlyAdmin(address caller);
    error ExceedsMaxSupply(uint256 current, uint256 addition, uint256 max);
    error NoActiveStake();
    error StakeAlreadyActive();
    error StakeBelowMinimum(uint256 amount, uint256 minimum);
    error StakingPeriodNotComplete(uint256 elapsed, uint256 required);
    error AlreadyAdmin(address admin);
    error NotAdmin(address admin);
    error CannotBlacklistOwner();
    error CannotBlacklistAdmin(address admin);
    error AlreadyBlacklisted(address user);
    error NotBlacklisted(address user);
    error AlreadyPaused();
    error NotPaused();
    error InvalidMinimum();
    error InvalidMaximum();
    error InvalidDuration(uint256 duration);
    error InsufficientContractBalance(uint256 available, uint256 required);
    
    // State variables (identical to Contract A)
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
        if (msg.sender != owner) revert OnlyOwner(msg.sender);
        _;
    }
    
    modifier onlyAdmin() {
        if (!admins[msg.sender] && msg.sender != owner) revert OnlyAdmin(msg.sender);
        _;
    }
    
    modifier whenNotPaused() {
        if (paused) revert ContractPaused();
        _;
    }
    
    // OPTIMIZED: Transfer function using custom errors
    function transfer(address to, uint256 amount) external whenNotPaused returns (bool) {
        if (to != address(0)) revert ZeroAddress();
        if (to == msg.sender) revert SelfTransfer();
        if (amount == 0) revert ZeroAmount();
        if (amount < minTransferAmount) revert AmountBelowMinimum(amount, minTransferAmount);
        if (amount > maxTransferAmount) revert AmountExceedsMaximum(amount, maxTransferAmount);
        if (balances[msg.sender] < amount) revert InsufficientBalance(balances[msg.sender], amount);
        if (blacklisted[msg.sender]) revert SenderBlacklisted(msg.sender);
        if (blacklisted[to]) revert RecipientBlacklisted(to);
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    // OPTIMIZED: Approve function using custom errors
    function approve(address spender, uint256 amount) external whenNotPaused returns (bool) {
        if (spender == address(0)) revert ZeroAddress();
        if (spender == msg.sender) revert SelfTransfer();
        if (amount > balances[msg.sender]) revert InsufficientBalance(balances[msg.sender], amount);
        if (blacklisted[msg.sender]) revert SenderBlacklisted(msg.sender);
        if (blacklisted[spender]) revert RecipientBlacklisted(spender);
        
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    // OPTIMIZED: TransferFrom using custom errors
    function transferFrom(address from, address to, uint256 amount) external whenNotPaused returns (bool) {
        if (from == address(0)) revert ZeroAddress();
        if (to == address(0)) revert ZeroAddress();
        if (from == to) revert SelfTransfer();
        if (amount == 0) revert ZeroAmount();
        if (amount < minTransferAmount) revert AmountBelowMinimum(amount, minTransferAmount);
        if (amount > maxTransferAmount) revert AmountExceedsMaximum(amount, maxTransferAmount);
        if (balances[from] < amount) revert InsufficientBalance(balances[from], amount);
        if (allowances[from][msg.sender] < amount) revert InsufficientAllowance(allowances[from][msg.sender], amount);
        if (blacklisted[from]) revert SenderBlacklisted(from);
        if (blacklisted[to]) revert RecipientBlacklisted(to);
        if (blacklisted[msg.sender]) revert CallerBlacklisted(msg.sender);
        
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    // OPTIMIZED: Minting function using custom errors
    function mint(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        if (totalSupply + amount > maxSupply) revert ExceedsMaxSupply(totalSupply, amount, maxSupply);
        if (blacklisted[to]) revert RecipientBlacklisted(to);
        
        balances[to] += amount;
        totalSupply += amount;
        
        emit Transfer(address(0), to, amount);
    }
    
    // OPTIMIZED: Burning function using custom errors
    function burn(uint256 amount) external whenNotPaused {
        if (amount == 0) revert ZeroAmount();
        if (balances[msg.sender] < amount) revert InsufficientBalance(balances[msg.sender], amount);
        if (blacklisted[msg.sender]) revert SenderBlacklisted(msg.sender);
        
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        
        emit Transfer(msg.sender, address(0), amount);
    }
    
    // OPTIMIZED: Staking function using custom errors
    function stake(uint256 amount) external whenNotPaused {
        if (amount < minStakeAmount) revert StakeBelowMinimum(amount, minStakeAmount);
        if (balances[msg.sender] < amount) revert InsufficientBalance(balances[msg.sender], amount);
        if (stakedBalances[msg.sender] != 0) revert StakeAlreadyActive();
        if (blacklisted[msg.sender]) revert SenderBlacklisted(msg.sender);
        
        balances[msg.sender] -= amount;
        stakedBalances[msg.sender] = amount;
        stakingTimestamps[msg.sender] = block.timestamp;
        
        emit Staked(msg.sender, amount);
    }
    
    // OPTIMIZED: Unstaking function using custom errors
    function unstake() external whenNotPaused {
        if (stakedBalances[msg.sender] == 0) revert NoActiveStake();
        
        uint256 elapsed = block.timestamp - stakingTimestamps[msg.sender];
        if (elapsed < stakingDuration) {
            revert StakingPeriodNotComplete(elapsed, stakingDuration);
        }
        
        if (blacklisted[msg.sender]) revert SenderBlacklisted(msg.sender);
        
        uint256 amount = stakedBalances[msg.sender];
        stakedBalances[msg.sender] = 0;
        stakingTimestamps[msg.sender] = 0;
        balances[msg.sender] += amount;
        
        emit Unstaked(msg.sender, amount);
    }
    
    // OPTIMIZED: Admin management using custom errors
    function addAdmin(address admin) external onlyOwner {
        if (admin == address(0)) revert ZeroAddress();
        if (admin == owner) revert AlreadyAdmin(admin);
        if (admins[admin]) revert AlreadyAdmin(admin);
        if (blacklisted[admin]) revert RecipientBlacklisted(admin);
        
        admins[admin] = true;
        emit AdminAdded(admin);
    }
    
    function removeAdmin(address admin) external onlyOwner {
        if (admin == address(0)) revert ZeroAddress();
        if (!admins[admin]) revert NotAdmin(admin);
        
        admins[admin] = false;
        emit AdminRemoved(admin);
    }
    
    // OPTIMIZED: Blacklist management using custom errors
    function blacklistAddress(address user) external onlyAdmin {
        if (user == address(0)) revert ZeroAddress();
        if (user == owner) revert CannotBlacklistOwner();
        if (admins[user]) revert CannotBlacklistAdmin(user);
        if (blacklisted[user]) revert AlreadyBlacklisted(user);
        
        blacklisted[user] = true;
    }
    
    function unblacklistAddress(address user) external onlyAdmin {
        if (user == address(0)) revert ZeroAddress();
        if (!blacklisted[user]) revert NotBlacklisted(user);
        
        blacklisted[user] = false;
    }
    
    // OPTIMIZED: Contract management using custom errors
    function pause() external onlyOwner {
        if (paused) revert AlreadyPaused();
        paused = true;
    }
    
    function unpause() external onlyOwner {
        if (!paused) revert NotPaused();
        paused = false;
    }
    
    function updateTransferLimits(uint256 min, uint256 max) external onlyOwner {
        if (min == 0) revert InvalidMinimum();
        if (max <= min) revert InvalidMaximum();
        if (max > maxSupply) revert AmountExceedsMaximum(max, maxSupply);
        
        minTransferAmount = min;
        maxTransferAmount = max;
    }
    
    function updateStakingParams(uint256 minAmount, uint256 duration) external onlyOwner {
        if (minAmount == 0) revert InvalidMinimum();
        if (duration < 1 days || duration > 365 days) revert InvalidDuration(duration);
        
        minStakeAmount = minAmount;
        stakingDuration = duration;
    }
    
    // OPTIMIZED: Emergency withdrawal using custom errors
    function emergencyWithdraw(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        if (balances[address(this)] < amount) {
            revert InsufficientContractBalance(balances[address(this)], amount);
        }
        
        balances[address(this)] -= amount;
        balances[to] += amount;
        
        emit Transfer(address(this), to, amount);
    }
}