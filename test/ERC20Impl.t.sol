// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {StdAssertions} from "../lib/forge-std/src/StdAssertions.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheats, StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

contract ERC20ImplTest is Test {

    ERC20Impl public erc20;

    // For Event Test
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        erc20 = new ERC20Impl();
    }

    function test_1() public {
        uint256 myBalance = erc20.balanceOf(address(this));
        assertEq(myBalance, type(uint256).max);

        vm.expectEmit();
        emit IERC20.Transfer(address(this), address(1), 10);
        erc20.transfer(address(1), 10);
    }
    
}
