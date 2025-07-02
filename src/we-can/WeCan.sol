// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {Pausable} from "../../lib/openzeppelin-contracts/contracts/security/Pausable.sol";
import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {EnumerableSet} from "../../lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";
import {DonationInstance} from "./DonationInstance.sol";
import {DonationMaker} from "./DonationMaker.sol";


contract WeCan is ERC20, Pausable, DonationMaker, Ownable {

    using EnumerableSet for EnumerableSet.AddressSet;


    constructor()
    Ownable()
    ERC20("WeCan Token", "WCAN")
    {
        ERC20._mint(_msgSender(), type(uint256).max);
    }

    /*============= Pausable =============*/

    /**
    * @dev Admin menghentikan kontrak
    */
    function pause() public onlyOwner whenNotPaused {
        super._pause();
    }

    /**
    * @dev Admin melanjutkan kontrak
    */
    function unpause() public onlyOwner whenPaused {
        super._unpause();
    }

    /*============= Bridge For ERC721 =============*/

    function addressDonationCounter(address donator)
    public
    view
    returns(uint256 totalDonationCounter)
    {
        return donatorAddressData[donator].totalDonationCounter;
    }

    function addressDonationAmount(address donator)
    public
    view
    returns(uint256 totalDonationAmount)
    {
        return donatorAddressData[donator].totalDonationAmount;
    }

    /*============= ERC20 =============*/

    /**
    * @dev Transfer cuma boleh di eksekusi ketika kontrak tidak dalam kondisi pause
    */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
    * @dev Event yang di-emit ketika pelimpahan terjadi di _afterTokenTransfer()
    */
    event PelimpahanEvent(
        address indexed donationInstance,
        uint256 amount,
        uint256 timestamp
    );

    /**
    * @dev Pengecekan donasi sudah eligible untuk pelimpahan setelah settlement selesai
    */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {

        // Super
        super._afterTokenTransfer(from, to, amount);

        // Aksi jika to adalah address donasi
        (bool isDonationAddress) = donationAddressSet.contains(to);
        if (isDonationAddress) {

            // Donation address harus belum finish
            require(!isDonationFinish[to],"Donation had finished");

            // Index Donator
            // TODO : FOR REMOVE
            super.indexDonator(from);

            // Update Donator Metadata
            super._updateDonatorMetadata(from,to,amount);

            // Register donatorInDonationAddress
            _donatorInDonationAddress[to].add(from);

            // Cek Pelimpahan jika address tujuan adalah instance donation
            DonationInstance instance = DonationInstance(to);
            if (
                // Jika target dicapai
                super.balanceOf(to) > instance.amountTarget() ||
                // Jika donation sudah expired
                instance.expiredAt() < block.timestamp
            ) {
                // Limpahkan
                super._transfer(to, instance.receiver(), super.balanceOf(to));
                isDonationFinish[to] = true;
                emit PelimpahanEvent(to, super.balanceOf(to), block.timestamp);
            }
        }
    }

    /*============= Donation Maker =============*/

    /*
    * @dev Membuat Metadata Donation
    * @dev Receiver tidak boleh address donation agar tidak looping
    */
    function createDonation(
        string memory title,
        string memory description,
        string memory imageUri,
        address receiver,
        uint256 amountTarget,
        uint256 duration
    ) public
    override
    requireNotDonationAddress(receiver)
    returns (bool) {
        return
            super.createDonation(
            title,
            description,
            imageUri,
            receiver,
            amountTarget,
            duration
        );
    }

    /*
    * @dev Batalkan donation dan refund seluruh amount yang sudah di donate.
    */
    function failDonation(address donationAddress) public onlyOwner {

        // Loop daftar donatur pada satu donation konotrak
        for (uint256 i = 0; i < _donatorInDonationAddress[donationAddress].length(); i++) {

            address intendedDonator = _donatorInDonationAddress[donationAddress].at(i);

            uint256[] memory amountDonated = donatorAddressData[intendedDonator]
                .donationLog[donationAddress];

            uint256 totalAmountDonated;

            for (uint256 j = 0; j < amountDonated.length; j++) {
                totalAmountDonated += amountDonated[j];
            }

            delete donatorAddressData[intendedDonator];

            ERC20._transfer(
                address(donationAddress),
                intendedDonator,
                totalAmountDonated
            );
        }
    }

    /*
    * @dev Mengambil donasi yang terkumpul pada kontrak donasi
    * @dev Address harus merupakan kontrak donasi
    */
    function getCollectedDonation(address donationAddress)
    public
    view
    override
    requireDonationAddress(donationAddress)
    returns (uint256)
    {
        return super.balanceOf(donationAddress);
    }

}

