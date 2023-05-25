// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract AssetManagement {
    struct Asset {
        address owner;
        string location;
        string condition;
    }

    mapping(uint256 => Asset) public assets;
    uint256 public assetCount;

    function addAsset(address _owner, string memory _location, string memory _condition) external {
        assets[assetCount] = Asset(_owner, _location, _condition);
        assetCount++;
    }

    function updateAssetLocation(uint256 _assetId, string memory _location) external {
        assets[_assetId].location = _location;
    }

    function updateAssetCondition(uint256 _assetId, string memory _condition) external {
        assets[_assetId].condition = _condition;
    }
}
