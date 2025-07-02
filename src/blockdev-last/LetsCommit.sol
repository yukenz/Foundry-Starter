// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {IEventIndexer} from "./IEventIndexer.sol";

contract LetsCommit is IEventIndexer {

    uint256 public eventId = 0;

    uint256 public eventIdClaim = 0;
    uint256 public eventIdEnroll = 0;

    constructor(){

    }

    function createScenarioEventOnSale() public {

        // Dummy Data for Event Creation ON SALE
        emit CreateEvent({
            eventId: 1,
            organizer: address(0x01),
            priceAmount: 50_000,
            commitmentAmount: 50_000,
            totalSession: 5,
            maxParticipant: 60,
            startSaleDate: block.timestamp - 1 days,
            endSaleDate: block.timestamp + 7 days
        });

        emit CreateEventMetadata({
            eventId: 1,
            title: "Tech Conference 2025",
            description: "A conference on the latest trends in technology.",
            location: "Los Angeles, CA",
            imageUri: "https://example.com/tech-conference.jpg",
            tag: ["technology", "conference", "2025", '', '']
        });

        emit CreateSession(1, 1, "Opening Keynote: The Future of Technology", block.timestamp + 8 days, block.timestamp + 9 days);
        emit CreateSession(1, 2, "AI Innovations: Transforming Industries", block.timestamp + 9 days, block.timestamp + 10 days);
        emit CreateSession(1, 3, "Blockchain and Decentralized Systems", block.timestamp + 10 days, block.timestamp + 11 days);
        emit CreateSession(1, 4, "Cloud Computing: Scaling the Future", block.timestamp + 11 days, block.timestamp + 12 days);
        emit CreateSession(1, 5, "Closing Remarks: Embracing Technological Change", block.timestamp + 12 days, block.timestamp + 13 days);

        // Enroll for Event 1 (Tech Conference 2025) - ON SALE
        emit EnrollEvent(1, address(0x11), 50_000 + 50_000); // Participant 1
        emit EnrollEvent(1, address(0x12), 50_000 + 50_000); // Participant 2
        emit EnrollEvent(1, address(0x13), 50_000 + 50_000); // Participant 3
        emit EnrollEvent(1, address(0x14), 50_000 + 50_000); // Participant 4
        emit EnrollEvent(1, address(0x15), 50_000 + 50_000); // Participant 5

    }

    function createScenarioEventOnGoing() public {

        // Data for second event ON GOING
        emit CreateEvent({
            eventId: 2,
            organizer: address(0x02),
            priceAmount: 100_000,
            commitmentAmount: 100_000,
            totalSession: 10,
            maxParticipant: 100,
            startSaleDate: block.timestamp - 7 days,
            endSaleDate: block.timestamp - 3 days
        });

        emit CreateEventMetadata({
            eventId: 2,
            title: "Blockchain Summit",
            description: "Exploring the future of blockchain and cryptocurrencies.",
            location: "New York, NY",
            imageUri: "https://example.com/blockchain-summit.jpg",
            tag: ["blockchain", "cryptocurrency", "summit", '', '']
        });

        // Sesi untuk Event 2 (Blockchain Summit) - ON GOING (10 sesi)
        emit CreateSession(2, 1, "Introduction to Blockchain Technology", block.timestamp - 7 days, block.timestamp - 6 days);
        emit CreateSession(2, 2, "Decentralized Finance: A New Era of Banking", block.timestamp - 6 days, block.timestamp - 5 days);
        emit CreateSession(2, 3, "Blockchain Security: Protecting Your Assets", block.timestamp - 5 days, block.timestamp - 4 days);
        emit CreateSession(2, 4, "NFTs and Digital Ownership", block.timestamp - 4 days, block.timestamp - 3 days);
        emit CreateSession(2, 5, "Smart Contracts: Automating the Future", block.timestamp - 3 days, block.timestamp - 2 days);
        emit CreateSession(2, 6, "Blockchain for Supply Chain Management", block.timestamp - 2 days, block.timestamp - 1 days);
        emit CreateSession(2, 7, "The Rise of Cryptocurrencies", block.timestamp - 1 days, block.timestamp);
        emit CreateSession(2, 8, "Regulations in the Blockchain Space", block.timestamp, block.timestamp + 1 days);
        emit CreateSession(2, 9, "Building Blockchain Applications", block.timestamp + 1 days, block.timestamp + 2 days);
        emit CreateSession(2, 10, "Future Trends in Blockchain Technology", block.timestamp + 2 days, block.timestamp + 3 days);

        // Enroll for Event 2 (Blockchain Summit) - ON GOING
        emit EnrollEvent(2, address(0x21), 100_000 + 100_000); // Participant 1
        emit EnrollEvent(2, address(0x22), 100_000 + 100_000); // Participant 2
        emit EnrollEvent(2, address(0x23), 100_000 + 100_000); // Participant 3
        emit EnrollEvent(2, address(0x24), 100_000 + 100_000); // Participant 4
        emit EnrollEvent(2, address(0x25), 100_000 + 100_000); // Participant 5

        // Organizer First Claim for Event 2 (Blockchain Summit) - ON GOING
        emit OrganizerFirstClaim(2, address(0x02), 500_000); // Organizer claims 50% from total funds

        // Generate Session Tokens for Event 2 (Blockchain Summit) - ON GOING
        emit GenerateSessionToken(2, 1, "token_session_1"); // Token untuk sesi 1
        emit GenerateSessionToken(2, 2, "token_session_2"); // Token untuk sesi 2
        emit GenerateSessionToken(2, 3, "token_session_3"); // Token untuk sesi 3
        emit GenerateSessionToken(2, 4, "token_session_4"); // Token untuk sesi 4
        emit GenerateSessionToken(2, 5, "token_session_5"); // Token untuk sesi 5

    }

    function createScenarioEventFinished() public {

        // Data for third event FINISHED
        emit CreateEvent({
            eventId: 3,
            organizer: address(0x03),
            priceAmount: 75_000,
            commitmentAmount: 75_000,
            totalSession: 8,
            maxParticipant: 150,
            startSaleDate: block.timestamp - 30 days,
            endSaleDate: block.timestamp - 20 days
        });

        emit CreateEventMetadata({
            eventId: 3,
            title: "Music Fest 2025",
            description: "A grand music festival featuring top artists from around the world.",
            location: "Miami, FL",
            imageUri: "https://example.com/music-fest.jpg",
            tag: ["music", "festival", "2025", '', '']
        });

        // Sesi untuk Event 3 (Music Fest 2025) - FINISHED (8 sesi)
        emit CreateSession(3, 1, "Opening Act: Welcome to the Music Fest!", block.timestamp - 30 days, block.timestamp - 29 days);
        emit CreateSession(3, 2, "Rock Legends: The Power of Live Performance", block.timestamp - 29 days, block.timestamp - 28 days);
        emit CreateSession(3, 3, "Electronic Beats: The Evolution of EDM", block.timestamp - 28 days, block.timestamp - 27 days);
        emit CreateSession(3, 4, "Indie Artists: The Rise of New Sounds", block.timestamp - 27 days, block.timestamp - 26 days);
        emit CreateSession(3, 5, "Pop Icons: Global Superstars and Their Impact", block.timestamp - 26 days, block.timestamp - 25 days);
        emit CreateSession(3, 6, "Hip-Hop & Rap: The Voice of a Generation", block.timestamp - 25 days, block.timestamp - 24 days);
        emit CreateSession(3, 7, "Jazz Fusion: Blending Genres in the Modern Age", block.timestamp - 24 days, block.timestamp - 23 days);
        emit CreateSession(3, 8, "Closing Performance: Celebrating Music Across the World", block.timestamp - 23 days, block.timestamp - 22 days);

        // Enroll for Event 3 (Music Fest 2025) - FINISHED
        emit EnrollEvent(3, address(0x31), 75_000 + 75_000); // Participant 1
        emit EnrollEvent(3, address(0x32), 75_000 + 75_000); // Participant 2
        emit EnrollEvent(3, address(0x33), 75_000 + 75_000); // Participant 3
        emit EnrollEvent(3, address(0x34), 75_000 + 75_000); // Participant 4
        emit EnrollEvent(3, address(0x35), 75_000 + 75_000); // Participant 5

        // Organizer First Claim for Event 3 (Music Fest 2025) - FINISHED
        emit OrganizerFirstClaim(3, address(0x03), 375_000); // Organizer claims 50% from total funds

        // Generate Session Tokens for Event 3 (Music Fest 2025) - FINISHED
        emit GenerateSessionToken(3, 1, "token_session_1"); // Token untuk sesi 1
        emit GenerateSessionToken(3, 2, "token_session_2"); // Token untuk sesi 2
        emit GenerateSessionToken(3, 3, "token_session_3"); // Token untuk sesi 3
        emit GenerateSessionToken(3, 4, "token_session_4"); // Token untuk sesi 4
        emit GenerateSessionToken(3, 5, "token_session_5"); // Token untuk sesi 5
        emit GenerateSessionToken(3, 6, "token_session_6"); // Token untuk sesi 6
        emit GenerateSessionToken(3, 7, "token_session_7"); // Token untuk sesi 7
        emit GenerateSessionToken(3, 8, "token_session_8"); // Token untuk sesi 8

        // Attend for Event 3 (Music Fest 2025) - FINISHED (8 sesi dengan token)
        emit AttendEventSession(3, 1, address(0x31), "token_session_1"); // Participant 1 attends Session 1
        emit AttendEventSession(3, 2, address(0x32), "token_session_2"); // Participant 2 attends Session 2
        emit AttendEventSession(3, 3, address(0x33), "token_session_3"); // Participant 3 attends Session 3
        emit AttendEventSession(3, 4, address(0x34), "token_session_4"); // Participant 4 attends Session 4
        emit AttendEventSession(3, 5, address(0x35), "token_session_5"); // Participant 5 attends Session 5
        emit AttendEventSession(3, 6, address(0x36), "token_session_6"); // Participant 6 attends Session 6
        emit AttendEventSession(3, 7, address(0x37), "token_session_7"); // Participant 7 attends Session 7
        emit AttendEventSession(3, 8, address(0x38), "token_session_8"); // Participant 8 attends Session 8

        // Organizer Last Claim for Event 3 (Music Fest 2025) - FINISHED
        emit OrganizerLastClaim(3, address(0x03), 375_000); // Organizer claims the remaining 50%
    }


    function emitCreateSession(uint8 i) internal returns (bool)  {

        emit CreateSession({
            eventId: eventId,
            session: i,
            title: string.concat("Session ", "1"),
            startSessionTime: block.timestamp + (1 days * i),
            endSessionTime: block.timestamp + (1 days * i) + (1 hours)
        });

        return true;
    }

    function createEvent() public returns (bool) {

        string[5] memory tags = ['satu', 'dua', '', '', ''];

        uint8 totalSession = 12;

        emit CreateEvent({
            eventId: ++eventId,
            organizer: address(0x0),
            priceAmount: 10_000,
            commitmentAmount: 10_000,
            totalSession: totalSession,
            maxParticipant: 60,
            startSaleDate: block.timestamp,
            endSaleDate: block.timestamp + 7 days
        });

        emit CreateEventMetadata({
            eventId: eventId,
            title: "title",
            description: "description",
            location: "Los Angels",
            imageUri: "imageUri",
            tag: tags
        });


        for (uint8 i = 0; i < totalSession; i++) {
            (bool isSuccess) = emitCreateSession(i);
        }

        return true;
    }

    function claim() public returns (bool) {

        emit OrganizerFirstClaim({
            eventId: ++eventIdClaim,
            organizer: address(0x0),
            claimAmount: 10_000 / 2
        });

        emit OrganizerLastClaim({
            eventId: eventIdClaim,
            organizer: address(0x0),
            claimAmount: 10_000 / 2
        });

        return true;
    }

    function enrollAndAttend() public returns (bool) {

        emit EnrollEvent({
            eventId: ++eventIdEnroll,
            participant: address(0x1),
            debitAmount: 10_000
        });

        emit AttendEventSession({
            eventId: eventIdEnroll,
            session: 1,
            participant: address(0x1),
            attendToken: (abi.encodePacked(block.timestamp, [1]))
        });

        emit OrganizerClaimUnattended({
            eventId: eventIdEnroll,
            session: 1,
            unattendedPerson: 3,
            organizer: address(0x0),
            claimAmount: 1_00
        });

        return true;
    }

}