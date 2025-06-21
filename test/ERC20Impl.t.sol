// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

contract ERC20ImplTest is Test {
    ERC20Impl public erc20;

    function setUp() public {
        erc20 = new ERC20Impl();
    }

    function test_1() public {
        assertEq(erc20.balanceOf(address(this)), type(uint256).max);
    }

//    function testFuzz_SetNumber(uint256 x) public {
//        counter.setNumber(x);
//        assertEq(counter.number(), x);
//    }
}
