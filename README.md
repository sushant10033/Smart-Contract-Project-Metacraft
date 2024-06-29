# Smart-Contract-Project-Metacraft
# SimpleBank Smart Contract

## Project Title
SimpleBank: A Basic Ethereum Bank Contract

## Simple Overview
The SimpleBank smart contract allows users to deposit and withdraw Ether, check their balance, and the owner can destroy the contract. It's a simple example to demonstrate basic Solidity concepts including `require()`, `assert()`, and `revert()` statements.

## Description
The SimpleBank smart contract is designed to mimic a basic banking system on the Ethereum blockchain. Users can interact with the contract by depositing Ether into their account, withdrawing Ether from their account, and checking their account balance. The contract owner has the additional ability to destroy the contract, returning any remaining Ether to themselves. This contract serves as a learning tool for understanding the implementation of basic Ethereum smart contract functions and error handling mechanisms in Solidity.

## Getting Started

### Installing

#### How/Where to Download Your Program
1. Open [Remix IDE](https://remix.ethereum.org) in your web browser.

#### Any Modifications Needed to Be Made to Files/Folders
No modifications are needed. Simply create a new file in Remix and copy the provided code.

### Executing Program

#### How to Run the Program

##### Step-by-Step Instructions
1. **Open Remix IDE:**
   - Go to [Remix IDE](https://remix.ethereum.org).

2. **Create a New File:**
   - In the file explorer on the left side, click on the "contracts" folder.
   - Click the "+" button to create a new file.
   - Name the file `SimpleBank.sol`.

3. **Copy and Paste the Code:**
   - Copy the smart contract code from this repository.
   - Paste the code into the `SimpleBank.sol` file you just created.

4. **Compile the Contract:**
   - Click on the "Solidity Compiler" tab on the left (it looks like a 'S' icon).
   - Make sure the compiler version matches the one specified in the code (`pragma solidity ^0.8.0;`). If not, select the appropriate version.
   - Click the "Compile SimpleBank.sol" button.

5. **Deploy the Contract:**
   - Click on the "Deploy & Run Transactions" tab on the left (it looks like an Ethereum icon).
   - Click the "Deploy" button under the "Deploy & Run Transactions" tab.

6. **Interact with the Contract:**
   - After deploying, the contract will appear under "Deployed Contracts."
   - Expand the deployed contract to see the available functions: `deposit`, `withdraw`, `balance`, and `kill`.

##### Example Code

```solidity
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
```

## Help
For common issues or problems, refer to the following advice:

Compiler Errors: Ensure you are using the correct Solidity version (^0.8.0). Check for any typos in the code.
Transaction Failures: Make sure you have enough Ether in your account for deposits and withdrawals.
Contract Ownership: Only the account that deployed the contract can call the kill function
# Authors
sushant10033

sushantraj893@gmail.com
## License
This project is licensed under the MIT License 

