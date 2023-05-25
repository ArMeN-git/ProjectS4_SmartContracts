// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract PaymentContract {
    address public logisticsProvider;
    address public customer;
    uint256 public invoiceAmount;
    bool public deliveryConfirmed;

    constructor(address _logisticsProvider, address _customer, uint256 _invoiceAmount) {
        logisticsProvider = _logisticsProvider;
        customer = _customer;
        invoiceAmount = _invoiceAmount;
        deliveryConfirmed = false;
    }

    function confirmDelivery() external {
        require(msg.sender == customer, "Only the customer can confirm delivery.");
        deliveryConfirmed = true;
    }

    function releasePayment() external {
        require(msg.sender == logisticsProvider, "Only the logistics provider can release payment.");
        require(deliveryConfirmed, "Delivery has not been confirmed yet.");
        // Transfer funds to the logistics provider
        payable(logisticsProvider).transfer(invoiceAmount);
    }
}
