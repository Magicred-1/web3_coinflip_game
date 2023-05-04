// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CoinFlip {
    address public manager;
    address payable[] public players;
    mapping(address => bool) public playerChoices;
    mapping(address => uint) public playerBets;

    constructor() {
        manager = msg.sender;
    }

    function flipCoin(bool choice) public payable {
        require(msg.value > 0, "Bet amount must be greater than 0");
        players.push(payable(msg.sender));
        playerChoices[msg.sender] = choice;
        playerBets[msg.sender] = msg.value;
    }

    function random() internal view returns (bool) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
        return (randomNumber % 2 == 0);
    }

    modifier restricted() {
        require(msg.sender == manager, "You are not the owner of this contract");
        _;
    }

    function pickWinner() public restricted {
        require(players.length > 0, "Need at least one player.");
        bool coinFlipResult = random();
        for (uint i = 0; i < players.length; i++) {
            address payable player = players[i];
            bool playerChoice = playerChoices[player];
            if (playerChoice == coinFlipResult) {
                player.transfer(playerBets[player] * 2);
            }
        }
        delete players;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}