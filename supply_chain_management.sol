// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SupplyChainContract {
    enum ShipmentStatus { InTransit, Delivered }

    struct Shipment {
        address logisticsProvider;
        address customer;
        uint256 milestonePayment;
        ShipmentStatus status;
    }

    mapping(uint256 => Shipment) public shipments;
    uint256 public shipmentCount;

    event ShipmentStatusUpdated(uint256 shipmentId, ShipmentStatus status);

    function createShipment(address _logisticsProvider, address _customer, uint256 _milestonePayment) external {
        shipments[shipmentCount] = Shipment(_logisticsProvider, _customer, _milestonePayment, ShipmentStatus.InTransit);
        shipmentCount++;
    }

    function updateShipmentStatus(uint256 _shipmentId, ShipmentStatus _status) external {
        shipments[_shipmentId].status = _status;
        emit ShipmentStatusUpdated(_shipmentId, _status);
    }

    function releaseMilestonePayment(uint256 _shipmentId) external {
        Shipment storage shipment = shipments[_shipmentId];
        require(shipment.status == ShipmentStatus.Delivered, "Shipment has not been delivered yet.");
        // Transfer milestone payment to the logistics provider
        payable(shipment.logisticsProvider).transfer(shipment.milestonePayment);
    }
}
