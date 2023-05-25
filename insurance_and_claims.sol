// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract InsuranceContract {
    address public insurer;
    mapping(address => uint256) public insuredAmounts;
    mapping(address => uint256) public claimAmounts;
    mapping(address => bool) public isClaimed;
    
    event InsurancePurchased(address indexed insured, uint256 amount);
    event ClaimFiled(address indexed insured, uint256 amount);
    event ClaimProcessed(address indexed insured, uint256 amount);
    
    constructor() {
        insurer = msg.sender;
    }
    
    function purchaseInsurance() external payable {
        require(msg.value > 0, "Insurance amount must be greater than zero.");
        
        insuredAmounts[msg.sender] += msg.value;
        emit InsurancePurchased(msg.sender, msg.value);
    }
    
    function fileClaim() external {
        require(insuredAmounts[msg.sender] > 0, "You don't have any insurance coverage.");
        require(!isClaimed[msg.sender], "Claim has already been filed.");
        
        claimAmounts[msg.sender] = insuredAmounts[msg.sender];
        isClaimed[msg.sender] = true;
        emit ClaimFiled(msg.sender, claimAmounts[msg.sender]);
    }
    
    function processClaim(address insured) external {
        require(msg.sender == insurer, "Only the insurer can process claims.");
        require(isClaimed[insured], "No claim has been filed by the insured.");
        
        uint256 claimAmount = claimAmounts[insured];
        claimAmounts[insured] = 0;
        payable(insured).transfer(claimAmount);
        emit ClaimProcessed(insured, claimAmount);
    }
}