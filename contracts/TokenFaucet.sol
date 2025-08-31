// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TokenFaucet {
    address public owner;
    uint256 public dripAmount = 1 ether;
    mapping(address => uint256) public lastDripTime;
    uint256 public cooldown = 1 hours;

    constructor() {
        owner = msg.sender;
    }

    function requestTokens() external {
        require(
            block.timestamp - lastDripTime[msg.sender] >= cooldown,
            "Wait before requesting again"
        );
        require(address(this).balance >= dripAmount, "Faucet is empty");
        lastDripTime[msg.sender] = block.timestamp;

        (bool success, ) = msg.sender.call{value: dripAmount}("");
        require(success, "Transfer failed");
    }

    function setDripAmount(uint256 _amount) external onlyOwner {
        dripAmount = _amount;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // 🆕 Added function
    function checkNextEligibleTime(address user) external view returns (uint256 secondsRemaining) {
        if (block.timestamp >= lastDripTime[user] + cooldown) {
            return 0; // Eligible now
        } else {
            return (lastDripTime[user] + cooldown) - block.timestamp;
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    receive() external payable {}
}
// "Added one function suggested by ChatGPT"
function setCooldown(uint256 _cooldown) external onlyOwner {
    cooldown = _cooldown;
} // "Added new function"

