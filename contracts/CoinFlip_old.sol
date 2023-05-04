// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract CoinFlip is VRFConsumerBase {
    // Define the possible outcomes as an enum
    enum Outcome { Tails, Heads }

    // Events
    event Deposit(address indexed user, uint256 amount);
    event FlipResult(bytes32 indexed requestId, address indexed flipper, uint256 betAmount, Outcome betOutcome);
    event OutcomeRevealed(bytes32 indexed requestId, address indexed flipper, Outcome outcome);

    // VRF parameters
    bytes32 internal keyHash;
    uint256 internal fee;

    // Mapping to store flip outcomes and player bets
    mapping(bytes32 => Outcome) public outcomes;
    mapping(bytes32 => uint256) public bets;
    mapping(address => uint256) public balances;

    // Constructor to initialize Chainlink VRF parameters
    constructor(address _vrfCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee)
        VRFConsumerBase(_vrfCoordinator, _linkToken) {
        keyHash = _keyHash;
        fee = _fee;
    }

    // Function to deposit funds
    function deposit() public payable {
        require(msg.value > 0, "No funds sent");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw funds
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Function to flip the coin
    function flip(uint256 betAmount, Outcome betOutcome) public returns (bytes32) {
        require(balances[msg.sender] >= betAmount, "Insufficient balance");
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to pay fee");

        balances[msg.sender] -= betAmount;
        bytes32 requestId = requestRandomness(keyHash, fee);
        bets[requestId] = betAmount;

        emit FlipResult(requestId, msg.sender, betAmount, betOutcome);
        return requestId;
    }

    // Callback function called by the VRF Coordinator
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        Outcome outcome = Outcome(randomness % 2);
        outcomes[requestId] = outcome;
        emit OutcomeRevealed(requestId, msg.sender, outcome);

        // Check if the player has won and credit the winnings
        address flipper = msg.sender;
        uint256 betAmount = bets[requestId];
        if (outcome == outcomes[requestId]) {
            uint256 winnings = betAmount * 2;
            balances[flipper] += winnings;
        }
    }

    // Function to claim the flip outcome
    function claimOutcome(bytes32 requestId) public view returns (Outcome) {
        require(outcomes[requestId] != Outcome.Tails || outcomes[requestId] != Outcome.Heads, "Outcome not available");
        return outcomes[requestId];
    }
}