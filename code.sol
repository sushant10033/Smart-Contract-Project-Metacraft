// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    mapping(address => uint) private balances;
    address public owner;

    // Event for logging deposits and withdrawals
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawalMade(address indexed accountAddress, uint amount);

    constructor() {
        owner = msg.sender;
    }

    // Function to deposit ether into the bank
    function deposit() public payable returns (uint) {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        balances[msg.sender] += msg.value;

        emit LogDepositMade(msg.sender, msg.value);

        return balances[msg.sender];
    }

    // Function to withdraw ether from the bank
    function withdraw(uint withdrawAmount) public returns (uint remainingBalance) {
        require(withdrawAmount <= balances[msg.sender], "Insufficient balance");

        // We use assert to check for conditions that should never be false
        assert(balances[msg.sender] >= withdrawAmount);

        balances[msg.sender] -= withdrawAmount;

        // Using call to send ether and handling failure with revert
        (bool success, ) = msg.sender.call{value: withdrawAmount}("");
        if (!success) {
            balances[msg.sender] += withdrawAmount;
            revert("Withdrawal failed");
        }

        emit LogWithdrawalMade(msg.sender, withdrawAmount);

        return balances[msg.sender];
    }

    // Function to check the balance of an account
    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Function to kill the contract and send remaining ether to the owner
    function kill() public {
        require(msg.sender == owner, "Only the owner can kill the contract");

        // Self-destruct the contract and send the remaining ether to the owner
        selfdestruct(payable(owner));
    }
}
