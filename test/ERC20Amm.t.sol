// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {StdAssertions} from "../lib/forge-std/src/StdAssertions.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheats, StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

// AMM Controller
contract AMMC {

    uint256 public constant LEG_AMOUNT = 5_000_000;
    uint256 public constant k = LEG_AMOUNT * LEG_AMOUNT;

    function swap(address tokenSource, address tokenDestination, uint256 amount) public {

        ERC20Impl src = ERC20Impl(tokenSource);
        ERC20Impl dst = ERC20Impl(tokenDestination);

        require(src.allowance(msg.sender, address(this)) >= amount, "Allowance kurang");

        uint256 srcBalance = src.balanceOf(address(this));
        uint256 dstBalance = dst.balanceOf(address(this));

        require(dstBalance >= amount, "LP tidak tersedia");

        uint256 dstNew = k / (srcBalance + amount);
        uint256 deltaNew = dstBalance - dstNew;
        console.log("Delta New = %s", deltaNew);

        src.transferFrom(msg.sender, address(this), amount);
        dst.transfer(msg.sender, deltaNew);
    }

}

contract ERC20AmmTest is Test {

    address constant public MINTER = address(99);

    ERC20Impl public A;
    ERC20Impl public B;
    AMMC public ammc;

    // For Event Test
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        console.log("Set Up Test");

        vm.startPrank(MINTER);
        A = new ERC20Impl();
        B = new ERC20Impl();
        vm.stopPrank();

        ammc = new AMMC();
    }

    function test_selectorLowLevelCall() public {

        vm.prank(MINTER);

        bytes memory payload = abi.encodeWithSignature("balanceOf(address)", MINTER);
        (bool success, bytes memory returnData) = address(A).call(payload);
        (uint256 data) = abi.decode(returnData,(uint256));

        console.log("%s", data);
    }


    function test_ammMechanism() public {
        console.log("Start Test");

        // Decimal harusnya 6 untuk USD
        assertEq(A.decimals(), 6, "Decimal A tidak 6");
        assertEq(B.decimals(), 6, "Decimal B tidak 6");

        // Minter membagi token ke address 1
        vm.startPrank(MINTER);
        A.transfer(address(1), 1_000_000);
        B.transfer(address(1), 1_000_000);
        vm.stopPrank();

        assertEq(A.balanceOf(address(1)), 1_000_000, "Balance A di address 1 tidak 100_000");
        assertEq(B.balanceOf(address(1)), 1_000_000, "Balance B di address 1 tidak 100_000");

        // Minter memasang LP
        vm.startPrank(MINTER);
        A.transfer(address(ammc), 5_000_000);
        B.transfer(address(ammc), 5_000_000);
        vm.stopPrank();

        assertEq(A.balanceOf(address(ammc)), 5_000_000, "Balance A di address 1 tidak 1_000");
        assertEq(B.balanceOf(address(ammc)), 5_000_000, "Balance B di address 1 tidak 1_000");

        // Address 1 memberi this A allowance, tanpa memberi B
        // A source, B destination
        vm.startPrank(address(1));
        A.approve(address(ammc), 500_000);
        vm.stopPrank();

        assertEq(A.allowance(address(1), address(ammc)), 500_000, "Allowance A tidak match");
        assertEq(B.allowance(address(1), address(ammc)), 0, "Allowance B tidak match");

        vm.startPrank(address(1));
        ammc.swap(address(A), address(B), 250_000);
        ammc.swap(address(A), address(B), 250_000);
        vm.stopPrank();

        console.log("A|%s x B|%s = C|%s", A.balanceOf(address(ammc)), B.balanceOf(address(ammc)), 5_000_000 * 5_000_000);

    }


}
