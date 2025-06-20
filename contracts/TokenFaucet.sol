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
        lastDripTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(dripAmount);
    }

    function setDripAmount(uint256 _amount) external onlyOwner {
        dripAmount = _amount;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    receive() external payable {}
}
