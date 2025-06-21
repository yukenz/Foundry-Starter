// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {StdAssertions} from "../lib/forge-std/src/StdAssertions.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheats, StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20Impl} from "../src/ERC20Impl.sol";

contract ERC20ImplTest is Test {

    ERC20Impl public erc20;

    // For Event Test
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        console.log("Set Up Test");
        erc20 = new ERC20Impl();
    }

    function test_transfer() public {
        console.log("Start Test");

        // decimal harusnya 6 untuk USD
        assertEq(erc20.decimals(), 6, "Decimal tidak 6");

        // Balance ku sesuai minting
        console.log("Balanceku %s", erc20.balanceOf(address(this)));
        assertEq(erc20.balanceOf(address(this)), type(uint256).max, "Balance ku tidak seperti pas minting");

        // Aku transfer
        vm.expectEmit();
        emit IERC20.Transfer(address(this), address(1), 100_000);
        erc20.transfer(address(1), 100_000);

        // 0x1 menerima transfer
        assertEq(erc20.balanceOf(address(1)), 100_000, "0x1 tidak menerima saldo");

        // 0x1 ngirim ke aku lagi
        vm.prank(address(1));
        erc20.transfer(address(this), 10_000);
        assertEq(erc20.balanceOf(address(1)), 90_000, "0x1 mengirimku namun tidak masuk");
    }

    function test_approve() public {

        // Aku approve 0x1 100_000
        erc20.approve(address(1), 100_000);
        assertEq(erc20.allowance(address(this), address(1)), 100_000, "test_approve1");

        // 0x1 spend punyaku ke 0x2
        vm.prank(address(1));
        erc20.transferFrom(address(this), address(2), 100_000);
        assertEq(erc20.balanceOf(address(2)), 100_000, "test_approve2");
        assertEq(erc20.allowance(address(this), address(1)), 0, "test_approve3");

        // 0x1 spend punyaku lagi ke 0x2 dan harusnya error
        vm.expectRevert();
        erc20.transferFrom(address(this), address(2), 100_000);

    }

}
