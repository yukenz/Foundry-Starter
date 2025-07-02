// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../../lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";
import {DonationInstance} from "./DonationInstance.sol";

abstract contract DonationMaker {
    using EnumerableSet for EnumerableSet.AddressSet;

    /**
     * @dev Metadata donatur ke donation address
     * @dev Di register pada createDonation() untuk totalDonatedAddressCreated
     * @dev Di register pada indexDonatur() untuk sisanya
     */
    struct DonatorAddressData {
        /**
         * @dev Metadata donator saat berdonasi
         * @dev Di register pada updateDonatorMetadata()
         */
        uint256 totalDonationCounter;
        uint256 totalDonationAmount;
        mapping(address => uint256[]) donationLog;
        /**
         * @dev Daftar alamat donasi yang dibuat creator
         * @dev Di register pada createDonation()
         */
        address[] donationAddress;
    }

    event NewDonatorIndexed(address indexed donator, uint256 timestamp);

    /**
     * @dev Address donator -> Metadata donator
     */
    mapping(address => DonatorAddressData) public donatorAddressData;

    /**
     * @dev Daftar alamat donasi yang valid berbentuk tipedata set
     * @dev Di register pada C._afterTokenTransfer
     */
    EnumerableSet.AddressSet internal donationAddressSet;

    /**
     * @dev Daftar alamat donasi yang sudah selesai
     * @dev Di register pada C._afterTokenTransfer
     */
    mapping(address=>bool) public isDonationFinish;

    /**
     * @dev SET of donators, untuk iterable
     */
    // TODO : FOR REMOVE
    EnumerableSet.AddressSet internal donators;

    /**
     * @dev Catatan donasi dari donator
     * @dev Address Donasi -> Address Donator[]
     * @dev Di register pada transfer()
     */
    mapping(address => EnumerableSet.AddressSet)
    internal _donatorInDonationAddress;

    /**
     * @dev Guard untuk pengecekan butuh alamat donasi valid
     */
    modifier requireDonationAddress(address donationAddress) {
        (bool isTrue) = donationAddressSet.contains(donationAddress);
        require(isTrue, "Address is not donation contract");
        _;
    }

    /**
     * @dev Guard untuk pengecekan butuh alamat donasi yang tidak valid
     */
    modifier requireNotDonationAddress(address donationAddress) {
        (bool isTrue) = donationAddressSet.contains(donationAddress);
        require(
            !isTrue,
            "Address is donation contract"
        );
        _;
    }

    /**
     * @dev Method untuk index donatur
     * @dev Method untuk Update Donator Data
     */
    // TODO : FOR REMOVE
    function indexDonator(address donatorAddress) internal returns (bool) {
        bool isDonatorIndexed = donators.contains(donatorAddress);

        if (!isDonatorIndexed) {
            donators.add(donatorAddress);
            emit NewDonatorIndexed(donatorAddress, block.timestamp);
        }

        return true;
    }

    /**
     * @dev Method untuk Update Donator Metadata ketika donate
     */
    function _updateDonatorMetadata(
        address donatorAddress,
        address donationAddress,
        uint256 amount
    ) internal {
        donatorAddressData[donatorAddress].totalDonationCounter += 1;
        donatorAddressData[donatorAddress].totalDonationAmount += amount;
        donatorAddressData[donatorAddress].donationLog[donationAddress].push(
            amount
        );
    }

    /**
     * @dev Spesifikasi method untuk mendapatkan donasi yang terkumpul
     * @dev Depends ke ERC-20
     */
    function getCollectedDonation(
        address donationAddress
    ) public
    view
    virtual
    returns (uint256);

    /**
     * @dev Untuk mendapatkan address donation dari creator
     */
    function getCreatedDonationAddress(
        address creator
    ) public view returns (address[] memory){
        return donatorAddressData[creator].donationAddress;
    }

    /**
     * @dev Menentukan apakah creator terverifikasi dengan cara dia sudah donasi minimum 10% dari target donasi yang dia buat
     */
    function isCreatorVerified(
        address donationAddress
    ) public view requireDonationAddress(donationAddress) returns (bool) {
        DonationInstance instance = DonationInstance(donationAddress);

        address creator = instance.creator();
        uint256 creatorDonated = totalDonatorAmountInDonationAddress(
            creator,
            donationAddress
        );

        return creatorDonated >= (instance.amountTarget() / 10);
    }

    /**
     * @dev Method untuk mendapatkan total amount dari donator di satu address donasi
     */
    function totalDonatorAmountInDonationAddress(
        address donatorAddress,
        address donationAddress
    ) public view returns (uint256) {
        // Dapatkan log donator per donasi address

        uint256[] memory donaturDonations = donatorAddressData[donatorAddress]
            .donationLog[donationAddress];

        // Jumlahkan amount
        uint256 totalAmount = 0;
        for (uint i = 0; i < donaturDonations.length; i++) {
            totalAmount += donaturDonations[i];
        }

        return totalAmount;
    }

    /**
     * @dev Event yang ter-emit ketika alamat donasi terbuat
     */
    event CreateDonationEvent(
        string title,
        address indexed creator,
        address indexed receiver,
        address indexed donationAddress,
        uint256 amountTarget,
        uint256 duration
    );

    /**
     * @dev Membuat alamat donasi dan metadata nya
     */
    function createDonation(
        string memory title,
        string memory description,
        string memory imageUri,
        address receiver,
        uint256 amountTarget,
        uint256 duration
    ) public virtual returns (bool) {
        DonationInstance donationInstance = new DonationInstance(
            title,
            description,
            imageUri,
            receiver,
            amountTarget,
            block.timestamp + duration,
            msg.sender
        );

        // Register Creator -> Donation Instance
        donatorAddressData[msg.sender].donationAddress.push(
            address(donationInstance)
        );

        // Register Address -> donationAddressSet
        donationAddressSet.add(address(donationInstance));

        emit CreateDonationEvent({
            title: title,
            creator: msg.sender,
            receiver: receiver,
            donationAddress: address(donationInstance),
            amountTarget: amountTarget,
            duration: duration
        });

        return true;
    }

    /**
     * @dev Method untuk mendapatkan total amount dari donator di satu address donasi
     */
    function getDonationAddress(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (address[] memory) {

        address[] memory donationAddressArray = donationAddressSet.values();
        uint256 length = endIndex - startIndex;

        // Ensure that startIndex and endIndex are within valid bounds
        require(length > 0, "Invalid index range");
        require(startIndex < length, "startIndex out of bounds");
        require(endIndex <= length, "endIndex out of bounds");
        require(startIndex < endIndex, "startIndex must be less than endIndex");

        address[] memory result = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = donationAddressArray[startIndex + i];
        }

        return result;
    }

    /**
     * @dev Method untuk mendapatkan total length dari donation address untuk pagination
     */
    function getDonationsAddressLength()
    public view returns(uint256){
        return donationAddressSet.length();
    }

}
