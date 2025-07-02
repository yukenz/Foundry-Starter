// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../src/blockdev-6/CampusCoin.sol";
import "../src/blockdev-6/SimpleDEX.sol";
import "../src/blockdev-6/MockUSDC.sol";
import {Script, console} from "forge-std/Script.sol";


contract DeployDEX is Script {
    // Contract instances
    CampusCoin public campusCoin;
    MockUSDC public usdc;
    SimpleDEX public dex;

    // Configuration
    uint256 public constant INITIAL_CAMP_LIQUIDITY = 1000 * 10**18;  // 1,000 CAMP
    uint256 public constant INITIAL_USDC_LIQUIDITY = 2000 * 10**6;   // 2,000 USDC

    function run() public returns (address, address, address) {
        console.log("Deploying Simple DEX to Monad Testnet...");
        console.log("");

        // Get deployer info
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deployer address:", deployer);
        console.log("Network: Monad Testnet (Chain ID: 10143)");

        // Check balance
        uint256 balance = deployer.balance;
        console.log("Deployer balance:", balance / 1e18, "MON");

        if (balance < 0.05 ether) {
            console.log("Warning: Low balance! Get MON from faucet:");
            console.log("https://faucet.testnet.monad.xyz/");
            console.log("");
        }

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy tokens
        console.log("Step 1: Loading tokens...");

        campusCoin =  CampusCoin(address(0x19DeEb2c7Ff873Fbd9aD0E381A8c7EACFFBcd5b1));
        console.log("CampusCoin loaded at:", address(campusCoin));

        usdc =  MockUSDC(address(0x6A723613B07Ccb9BB0Dc7f1f708493B2e7155A40));
        console.log("MockUSDC loaded at:", address(usdc));

        // Step 2: Deploy DEX
        console.log("");
        console.log("Step 2: Loading DEX...");

        dex =  SimpleDEX(address(0xE7BE5FbF73696327d4c7C7Dd41B975060310027F));
        console.log("SimpleDEX loaded at:", address(dex));

        // Step 3: Setup initial liquidity
        console.log("");
        console.log("Step 3: Setting up initial liquidity...");

        // Mint additional tokens for liquidity
        campusCoin.mint(deployer, INITIAL_CAMP_LIQUIDITY + 5000 * 10**18); // Extra for testing
        usdc.mint(deployer, INITIAL_USDC_LIQUIDITY + 10000 * 10**6);       // Extra for testing


        // Approve DEX
        campusCoin.approve(address(dex), type(uint256).max);
        usdc.approve(address(dex), type(uint256).max);

        // Add initial liquidity
        uint256 liquidity = dex.addLiquidity(INITIAL_CAMP_LIQUIDITY, INITIAL_USDC_LIQUIDITY);
        console.log("Initial liquidity added:", liquidity, "LP tokens");

        vm.stopBroadcast();

        // Step 4: Verification
        console.log("");
        console.log("Step 4: Deployment verification...");

        _verifyDeployment();

        // Step 5: Instructions
        console.log("");
        console.log("Step 5: How to use your DEX...");

        _printInstructions();

        return (address(campusCoin), address(usdc), address(dex));
    }

    function _verifyDeployment() internal view {
        // Verify token properties
        console.log("CampusCoin:");
        console.log("Name:", campusCoin.name());
        console.log("Symbol:", campusCoin.symbol());
        console.log("Total Supply:", campusCoin.totalSupply() / 10**18, "CAMP");

        console.log("MockUSDC:");
        console.log("Name:", usdc.name());
        console.log("Symbol:", usdc.symbol());
        console.log("Total Supply:", usdc.totalSupply() / 10**6, "USDC");

        // Verify DEX
        (uint256 reserveA, uint256 reserveB, uint256 totalLiquidity, uint256 price) = dex.getPoolInfo();
        console.log("SimpleDEX:");
        console.log("CAMP Reserve:", reserveA / 10**18);
        console.log("USDC Reserve:", reserveB / 10**6);
        console.log("Total Liquidity:", totalLiquidity);
        console.log("Current Price:", price / 1e18, "USDC per CAMP");
    }

    function _printInstructions() internal view {
        console.log("1. Get test tokens:");
        console.log("CAMP: Already minted to deployer");
        console.log("USDC: Use faucet() function");
        console.log("");

        console.log("2. Add liquidity:");
        console.log("Approve both tokens to DEX");
        console.log("Call addLiquidity(amountCAMP, amountUSDC)");
        console.log("");

        console.log("3. Swap tokens:");
        console.log("CAMP to USDC: swapAforB(amount, minOut)");
        console.log("USDC to CAMP: swapBforA(amount, minOut)");
        console.log("");

        console.log("4. Remove liquidity:");
        console.log("Call removeLiquidity(lpTokenAmount)");
        console.log("");

        console.log("Contract Addresses:");
        console.log("CampusCoin:", address(campusCoin));
        console.log("MockUSDC:  ", address(usdc));
        console.log("SimpleDEX: ", address(dex));
        console.log("");

        console.log("Block Explorer:");
        console.log("https://testnet.monadexplorer.com/address/", address(dex));
    }
}