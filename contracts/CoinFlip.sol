pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract coin_flip {
    address payable owner;
    address payable player;

    constructor() public {
        owner = payable(msg.sender);
    }

    function flip() public payable {
        require(msg.value == 0.002 ether, "Must send 1 ether");
        uint256 time = block.timestamp;
        uint256 bet = time % 2;
        if (bet == 0) {
            owner.transfer(2 ether);
        } else {
            player = payable(msg.sender);
            player.transfer(2 ether);
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        owner.transfer(address(this).balance);
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getPlayer() public view returns (address) {
        return player;
    }

}