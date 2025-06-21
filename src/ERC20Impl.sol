// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract ERC20Impl is ERC20 {
    constructor() ERC20("We Can", "WCAN") {
        super._mint(msg.sender,type(uint256).max);
    }

    // For USD
    function decimals() public view override returns (uint8) {
        return 6;
    }
}