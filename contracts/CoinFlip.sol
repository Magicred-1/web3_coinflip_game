// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract LotteryCoinFlip is VRFV2WrapperConsumerBase {
    struct Player {
        uint256 betAmount;
        uint256 betSide;
    }

    mapping(address => Player) public players;

    uint256 public randomResult;

    uint256 public totalBetAmount;

    uint256 public totalBetSide;


    constructor(
        address _vrfCoordinator,
        address _link,
        bytes32 _keyHash,
        uint256 _fee
    ) VRFV2WrapperConsumerBase(_vrfCoordinator, _link, _keyHash, _fee) {}

    function flipCoin(uint256 _betSide) public payable returns (bytes32 requestId) {
        require(_betSide == 0 || _betSide == 1, "Invalid bet side");
        require(msg.value > 0, "Invalid bet amount");
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");

        bytes32 _requestId = requestRandomness(keyHash, fee);
        players[msg.sender] = Player(msg.value, _betSide);
        totalBetAmount += msg.value;
        totalBetSide += _betSide;
        return _requestId;
    }