// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract SingleTest is Test {

    function setUp() public {
    }

    function test_ECDSASimulation() public pure {

        bytes32 hashSignature = ECDSA.toEthSignedMessageHash(bytes("Hello World"));

        bytes memory signature = hex"65e72b1cf8e189569963750e10ccb88fe89389daeeb8b735277d59cd6885ee823eb5a6982b540f185703492dab77b863a88ce01f27e21ade8b2879c10fc9e6531c";

        (address signer) = ECDSA.recover(hashSignature, signature);

//        bytes memory hexChars = "0123456789abcdef";
//        bytes memory str = new bytes(2 + signature.length * 2);
//        str[0] = "0";
//        str[1] = "x";
//        for (uint i = 0; i < signature.length; i++) {
//            str[2 + i * 2]     = hexChars[uint8(signature[i] >> 4)];
//            str[3 + i * 2] = hexChars[uint8(signature[i] & 0x0f)];
//        }


        console.log("Signature: %s", signer);
    }

}
