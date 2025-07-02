// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {WeCan} from "../src/we-can/WeCan.sol";

contract WeCanScript is Script {

    WeCan public wecan;

    function run() public returns (address) {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        wecan = new WeCan();
        wecan.createDonation({
            title: "Test Title 1",
            description: "Test Description",
            imageUri: "https://i.pinimg.com/736x/0d/3d/44/0d3d44215d1f424de4fa86f28c8bcd55.jpg",
            receiver: vm.addr(vm.envUint("PRIVATE_KEY")),
            amountTarget: 10_000,
            duration: block.timestamp + 30 days
        });

        wecan.createDonation({
            title: "Test Title 2",
            description: "Test Description",
            imageUri: "https://i.pinimg.com/736x/0d/3d/44/0d3d44215d1f424de4fa86f28c8bcd55.jpg",
            receiver: vm.addr(vm.envUint("PRIVATE_KEY")),
            amountTarget: 10_000,
            duration: block.timestamp + 30 days
        });

        wecan.createDonation({
            title: "Test Title 2",
            description: "Test Description",
            imageUri: "https://i.pinimg.com/736x/0d/3d/44/0d3d44215d1f424de4fa86f28c8bcd55.jpg",
            receiver: vm.addr(vm.envUint("PRIVATE_KEY")),
            amountTarget: 10_000,
            duration: block.timestamp + 30 days
        });

        (address[] memory donations) = wecan.getCreatedDonationAddress(vm.addr(vm.envUint("PRIVATE_KEY")));

        console.log("Created Donation list :");

        for (uint i = 0; i < donations.length; i++) {
            console.log("%s - %s", i, donations[i]);
            console.log("   Transfered 1_000");
            wecan.transfer(donations[i], 1_000);
        }

        console.log("BalanceOf :");

        for (uint i = 0; i < donations.length; i++) {
            console.log("%s - %s", i, wecan.balanceOf(donations[i]));
        }

        vm.stopBroadcast();

        return address(wecan);
    }

    function _verifyDeployment() internal view {
    }

}