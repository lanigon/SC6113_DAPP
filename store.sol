// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    mapping(address => uint256) public balances;

    struct Transaction {
        address payer;
        address payee;
        uint256 amount;
        uint256 timestamp;
    }

    Transaction public lastTransaction;

    function deposit(uint256 amount) public {
        require(amount > 0, "<=0");
        balances[msg.sender] += amount;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function transfer(uint256 amount, address payer, address payee) public {
        require(amount > 0, "<=0");
        require(balances[payer] >= amount, "not enough");
        require(payee != address(0), "invalid payee");
        require(msg.sender == payer, "not owner");

        balances[payer] -= amount;
        balances[payee] += amount;

        lastTransaction = Transaction({
            payer: payer,
            payee: payee,
            amount: amount,
            timestamp: block.timestamp
        });
    }

    function check_transaction() public view returns (address, address, uint256) {
        return (
            lastTransaction.payer,
            lastTransaction.payee,
            lastTransaction.amount
        );
    }
}
