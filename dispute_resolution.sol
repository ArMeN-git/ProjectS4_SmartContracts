// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract DisputeResolutionContract {
    enum DisputeStatus { None, Mediation, Arbitration, Resolved }
    
    struct Dispute {
        address customer;
        address provider;
        DisputeStatus status;
        uint256 disputedAmount;
        string details;
    }
    
    mapping(uint256 => Dispute) public disputes;
    uint256 public disputeCount;
    
    event DisputeFiled(uint256 indexed disputeId, address indexed customer, address indexed provider, uint256 disputedAmount, string details);
    event DisputeResolved(uint256 indexed disputeId, DisputeStatus status);
    
    modifier onlyInvolvedParties(uint256 disputeId) {
        require(disputes[disputeId].customer == msg.sender || disputes[disputeId].provider == msg.sender, "Only involved parties can perform this action.");
        _;
    }
    
    function fileDispute(address provider, uint256 disputedAmount, string memory details) external {
        require(disputedAmount > 0, "Disputed amount must be greater than zero.");
        
        disputeCount++;
        disputes[disputeCount] = Dispute(msg.sender, provider, DisputeStatus.Mediation, disputedAmount, details);
        
        emit DisputeFiled(disputeCount, msg.sender, provider, disputedAmount, details);
    }
    
    function initiateArbitration(uint256 disputeId) external onlyInvolvedParties(disputeId) {
        require(disputes[disputeId].status == DisputeStatus.Mediation, "Dispute must be in mediation status to initiate arbitration.");
        
        disputes[disputeId].status = DisputeStatus.Arbitration;
        
        emit DisputeResolved(disputeId, DisputeStatus.Arbitration);
    }
    
    function resolveDispute(uint256 disputeId, DisputeStatus resolutionStatus) external onlyInvolvedParties(disputeId) {
        require(disputes[disputeId].status == DisputeStatus.Mediation || disputes[disputeId].status == DisputeStatus.Arbitration, "Dispute must be in mediation or arbitration status.");
        
        disputes[disputeId].status = resolutionStatus;
        
        emit DisputeResolved(disputeId, resolutionStatus);
    }
}
