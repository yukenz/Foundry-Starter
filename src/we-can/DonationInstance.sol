// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
* @dev Alamat donasi yang berisikan metadata
*/
contract DonationInstance {

    string public title;
    string public description;
    string public imageUri;
    address public receiver;
    uint256 public amountTarget;
    uint256 public expiredAt;
    address public creator;

    constructor(
        string memory _title,
        string memory _description,
        string memory _imageUri,
        address _receiver,
        uint256 _amountTarget,
        uint256 _expiredAt,
        address _creator
    ) {
        title = _title;
        description = _description;
        imageUri = _imageUri;
        receiver = _receiver;
        amountTarget = _amountTarget;
        expiredAt = _expiredAt;
        creator = _creator;
    }

    function getMetadata() public view returns (
        string memory,
        string memory,
        string memory,
        address,
        uint256,
        uint256,
        address
    ) {
        return (
            title,
            description,
            imageUri,
            receiver,
            amountTarget,
            expiredAt,
            creator
        );
    }
}
