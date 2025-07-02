// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IEventIndexer_v1 {

    // ============= EO

    /**
     * @dev Log ketika event dibuat.
     */
    event CreateEvent(
        uint256 indexed eventId,
        string title,
        string description,
        string location,
        string imageUri,
        uint256 priceAmount,
        uint256 commitmentAmount,
        uint8 totalSession,
        uint8 maxParticipant,
        uint256 startSaleDate,
        uint256 endSaleDate,
        address organizer,
        string[5] tag
    );

    /**
     * @dev Log ketika session dibuat.
     */
    event CreateSession(
        uint256 indexed eventId,
        uint8 indexed session,
        string title,
        uint256 startSessionTime,
        uint256 endSessionTime
    );

    /**
     * @dev Log ketika session token dibuat.
     */
    event GenerateSessionToken(
        uint256 indexed eventId,
        uint8 indexed session,
        string token
    );

    /**
     * @dev Log ketika EO mengklaim 50% keuntungan setelah event berakhir masa penjualan.
     */
    event OrganizerFirstClaim(
        uint256 indexed eventId,
        address organizer,
        uint256 claimAmount
    );

    /**
     * @dev Log ketika EO mengklaim 50% keuntungan setelah semua sesi event berakhir
     */
    event OrganizerLastClaim(
        uint256 indexed eventId,
        address organizer,
        uint256 claimAmount
    );

    /**
     * @dev Log ketika EO mengklaim commitment fee participant yang tidak hadir setelah satu sesi event berakhir.
     */
    event OrganizerClaimUnattended(
        uint256 indexed eventId,
        uint8 indexed session,
        uint8 unattendedPerson,
        address organizer,
        uint256 claimAmount
    );

// ============= Participant

/**
 * @dev Log ketika Participant bergabung di event
     */
    event EnrollEvent(
        uint256 indexed eventId,
        address indexed participant,
        uint256 debitAmount
    );

/**
 * @dev Log ketika Participant menghadiri sesi event
     */
    event AttendEventSession(
        uint256 indexed eventId,
        uint8 indexed session,
        address indexed participant,
        bytes attendToken
    );
}
