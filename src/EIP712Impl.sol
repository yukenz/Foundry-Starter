pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol";

contract EIP712Impl is EIP712 {

    enum CSSOperation {
        REGISTER, // 0
        ACCESS // 1
    }

    struct CardSelfService {
        CSSOperation operation; // REGISTER / ACCESS
        bytes32 hashCard;
        bytes32 hashPin;
    }

    struct CardRequestPayment {
        bytes32 hashCard;
        bytes32 hashPin;
        string merchantId;
        string merchantKey;
        string terminalId;
        string terminalKey;
        uint256 paymentAmount;
    }

    bytes32 private immutable CARD_SELFSERVICE_TYPED_DATA_HASH;
    bytes32 private immutable CARD_REQUEST_PAYMENT_TYPED_DATA_HASH;

    ERC20 private immutable IDRX;

    constructor() EIP712("Walle", "1") {
        CARD_SELFSERVICE_TYPED_DATA_HASH = keccak256("CardSelfService(uint8 operation,bytes32 hashCard,bytes32 hashPin)");
        CARD_REQUEST_PAYMENT_TYPED_DATA_HASH = keccak256("CardRequestPayment(bytes32 hashCard,bytes32 hashPin,string merchantId,string merchantKey,string terminalId,string terminalKey,uint256 paymentAmount)");
        IDRX = ERC20(address(0));
    }

    function _hashTypedData(CardRequestPayment memory typedData) internal view returns (bytes32){
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    CARD_REQUEST_PAYMENT_TYPED_DATA_HASH,
                    typedData.hashCard,
                    typedData.hashPin,
                    keccak256(bytes(typedData.merchantId)),
                    keccak256(bytes(typedData.merchantKey)),
                    keccak256(bytes(typedData.terminalId)),
                    keccak256(bytes(typedData.terminalKey)),
                    typedData.paymentAmount
                )
            )
        );
    }

    function _hashTypedData(CardSelfService memory typedData) internal view returns (bytes32){
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    CARD_SELFSERVICE_TYPED_DATA_HASH,
                    uint8(typedData.operation),
                    typedData.hashCard,
                    typedData.hashPin
                )
            )
        );
    }

    function _verify(CardRequestPayment memory typedData, bytes memory signature) internal view returns (address){
        bytes32 digest = _hashTypedData(typedData);
        return ECDSA.recover(digest, signature);
    }

    function _verify(CardSelfService memory typedData, bytes memory signature) internal view returns (address){
        bytes32 digest = _hashTypedData(typedData);
        return ECDSA.recover(digest, signature);
    }

    function getSignerCardSelfService(
        CSSOperation operation,
        bytes32 hashCard,
        bytes32 hashPin,
        bytes memory signature
    ) public view returns (address){
        CardSelfService memory css = CardSelfService(operation, hashCard, hashPin);
        address signer = _verify(css, signature);
        return signer;
    }

    function getSignerCardRequestPayment(
        bytes32 hashCard,
        bytes32 hashPin,
        string memory merchantId,
        string memory merchantKey,
        string memory terminalId,
        string memory terminalKey,
        uint256 paymentAmount,
        bytes memory signature
    ) public view returns (address){
        CardRequestPayment memory crp = CardRequestPayment(hashCard, hashPin, merchantId, merchantKey, terminalId, terminalKey, paymentAmount);
        address signer = _verify(crp, signature);
        return signer;
    }

}