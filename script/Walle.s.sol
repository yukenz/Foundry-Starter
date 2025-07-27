// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";
import {EIP712Impl} from "../src/EIP712Impl.sol";

contract CounterScript is Script {

    function hexToUint256(string memory hexString) public pure returns (uint256) {
        // Convert hex string to bytes
        bytes memory hexBytes = bytes(hexString);

        // Ensure that the length of the bytes is valid (64 characters for uint256)
        require(hexBytes.length == 66, "Hex string must be 66 characters (0x + 64 hex digits)");

        uint256 result;

        // Loop through the bytes and convert to uint256
        for (uint256 i = 2; i < hexBytes.length; i++) { // Skip the '0x' prefix
            uint8 byteValue = uint8(hexBytes[i]);
            uint256 hexDigit;
            if (byteValue >= 48 && byteValue <= 57) {
                hexDigit = byteValue - 48;  // Convert ASCII '0'-'9' to 0-9
            } else if (byteValue >= 65 && byteValue <= 70) {
                hexDigit = byteValue - 55;  // Convert ASCII 'A'-'F' to 10-15
            } else if (byteValue >= 97 && byteValue <= 102) {
                hexDigit = byteValue - 87;  // Convert ASCII 'a'-'f' to 10-15
            } else {
                revert("Invalid hex character");
            }

            result = result * 16 + hexDigit;  // Shift left by 4 bits (multiply by 16) and add the digit
        }

        return result;
    }

    function setUp() public {}

    function run() public {

        uint256 deployerPrivateKey = hexToUint256("0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80");
        uint256 allowancePrivateKey = hexToUint256("0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d");

        address deployer = vm.addr(deployerPrivateKey);
        address allowance = vm.addr(allowancePrivateKey);

        console.log("Deployer : %s", deployer);

        vm.startBroadcast(deployerPrivateKey);

        ERC20Impl erc20 = new ERC20Impl();
        erc20.approve(allowance,20_000);

        EIP712Impl eip712 = new EIP712Impl();

        console.log("ERC 20 Address : %s", address(erc20));
        console.log("EIP712 Address : %s", address(eip712));

        vm.stopBroadcast();
    }
}
