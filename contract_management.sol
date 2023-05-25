// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ContractManagement {
    address public logisticsProvider;
    address public customer;
    uint256 public penaltyAmount;
    bool public contractCompleted;

    constructor(address _logisticsProvider, address _customer, uint256 _penaltyAmount) {
        logisticsProvider = _logisticsProvider;
        customer = _customer;
        penaltyAmount = _penaltyAmount;
        contractCompleted = false;
    }

    function completeContract() external {
        require(msg.sender == logisticsProvider, "Only the logistics provider can complete the contract.");
        contractCompleted = true;
    }

    function processPenaltyPayment() external {
        require(msg.sender == customer, "Only the customer can process the penalty payment.");
        require(!contractCompleted, "The contract has already been completed.");
        // Transfer penalty amount from the customer to the logistics provider
        payable(logisticsProvider).transfer(penaltyAmount);
    }
}
