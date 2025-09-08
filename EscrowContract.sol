// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// deposit - payer to escrow
// refund - escrow to payer
// release - escrow to payee
// events included

contract EscrowContract {
    address public buyer;
    address public seller;
    uint256 public amount;
    bool public isCompleted;

    event DepositEvent(address indexed from, uint256 value);
    event RefundEvent(address indexed to, uint256 value);
    event ReleaseEvent(address indexed from, address indexed to, uint256 value);

    constructor(address _seller) {
        buyer = msg.sender; // deployer is buyer
        seller = _seller;
    }

    // Buyer deposits Ether into escrow
    function deposit() external payable {
        require(msg.sender == buyer, "Only buyer can deposit");
        require(msg.value > 0, "Deposit must be greater than zero");
        require(amount == 0, "Already deposited");

        amount = msg.value;

        emit DepositEvent(msg.sender, msg.value);
    }

    // Refund Ether to buyer
    function refund() external {
        require(msg.sender == buyer, "Only buyer can refund");
        require(amount > 0, "No funds in escrow");
        require(!isCompleted, "Escrow already completed");

        uint256 refundAmount = amount;
        amount = 0;
        isCompleted = true;

        payable(buyer).transfer(refundAmount);

        emit RefundEvent(buyer, refundAmount);
    }

    // Release Ether to seller
    function release() external {
        require(msg.sender == buyer, "Only buyer can release funds");
        require(amount > 0, "No funds in escrow");
        require(!isCompleted, "Escrow already completed");

        uint256 payment = amount;
        amount = 0;
        isCompleted = true;

        payable(seller).transfer(payment);

        emit ReleaseEvent(buyer, seller, payment);
    }
}
