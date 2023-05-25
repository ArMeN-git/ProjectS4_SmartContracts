// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract CustomsContract {
    struct ShippingDocument {
        bytes32 documentHash;
        bool verified;
    }

    mapping(uint256 => ShippingDocument) public shippingDocuments;
    uint256 public documentCount;

    function submitShippingDocument(bytes32 _documentHash) external {
        shippingDocuments[documentCount] = ShippingDocument(_documentHash, false);
        documentCount++;
    }

    function verifyShippingDocument(uint256 _documentId) external {
        require(!shippingDocuments[_documentId].verified, "The document has already been verified.");
        shippingDocuments[_documentId].verified = true;
    }
}
