// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseAccount} from "../../lib/account-abstraction/contracts/core/BaseAccount.sol";
import {SIG_VALIDATION_FAILED} from "../../lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "../../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from "../../lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {ECDSA} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract SimpleSCW is BaseAccount {
//    using ECDSA for bytes32;

    address public owner;
    IEntryPoint private immutable _entryPoint;

    constructor(address _owner, IEntryPoint entryPoint) {
        owner = _owner;
        _entryPoint = entryPoint;
    }

    // Validate user's signature
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
    internal view override returns (uint256)
    {
        bytes32 signedHash = ECDSA.toEthSignedMessageHash(userOpHash);
        (address recAddress) = ECDSA.recover(signedHash, userOp.signature);

        if (owner != recAddress) {
            return SIG_VALIDATION_FAILED;
        }
        return 0;
    }

    // Execute a transaction (called by EntryPoint)
    function execute(address dest, uint256 value, bytes calldata func) external {
        _requireFromEntryPoint();
        (bool success,) = dest.call{value: value}(func);
        require(success, "SCW: execution failed");
    }

    // Required by BaseAccount
    function entryPoint() public view override returns (IEntryPoint) {
        return _entryPoint;
    }
}