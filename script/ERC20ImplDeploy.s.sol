// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

contract ERC20ImplScript is Script {
    ERC20Impl public erc20;

    function setUp() public {}

    function run() public {

        // Get deployer account from private key

        // read dotEnv
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deployment Details:");
        console.log("Deployer address:", deployer);

        // Check balance
        uint256 balance = deployer.balance;
        console.log("Deployer balance:", balance / 1e18, "EVM");

        vm.startBroadcast();

        erc20 = new ERC20Impl();

        vm.stopBroadcast();
    }
}
