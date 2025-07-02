// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {LetsCommit} from "../src/blockdev-last/LetsCommit.sol";

contract IEventSetupTest is Script {


    LetsCommit public c;

    function run() public {

        vm.startBroadcast();

        c = new LetsCommit();
//
//
//        for (uint i = 0; i < 20; i++) {
//
//            c.createEvent();
//            c.claim();
//            c.enrollAndAttend();
//
//        }

        c.createScenarioEventOnSale();
        c.createScenarioEventOnGoing();
        c.createScenarioEventFinished();

        vm.stopBroadcast();

    }
}