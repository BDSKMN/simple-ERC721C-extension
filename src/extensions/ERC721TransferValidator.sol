// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ICreatorToken} from "../interfaces/ICreatorToken.sol";
import {ITransferValidator721} from "../interfaces/ITransferValidator721.sol";

/// @title  ERC721TransferValidator
/// @author BDSKMN (@BDSKMN)
///         Modified from ProjectOpenSea's ERC721TransferValidator:
///         https://github.com/ProjectOpenSea/seadrop/blob/main/src/lib/ERC721TransferValidator.sol
/// @notice Abstract contract for ERC721 transfer validation.
/// @dev    Designed for ERC721 contracts implementing OpenSea's creator fee standard:
///         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
abstract contract ERC721TransferValidator is ICreatorToken {
    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @dev ERC721 transfer validation function signature.
    bytes4 private constant _ERC721_TRANSFER_VALIDATION_FUNCTION_SIGNATURE = 0xcaee23ea;

    /// @dev Interface ID for ICreatorToken.
    bytes4 internal constant INTERFACE_ID_ICREATORTOKEN = 0xad0d7f6c;

    /*//////////////////////////////////////////////////////////////
                              STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev Address of the transfer validator contract.
    ITransferValidator721 internal _transferValidator;

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc ICreatorToken
    function getTransferValidator() public view override returns (address) {
        return address(_transferValidator);
    }

    /// @inheritdoc ICreatorToken
    function getTransferValidationFunction()
        public
        pure
        override
        returns (bytes4 functionSignature, bool isViewFunction)
    {
        functionSignature = _ERC721_TRANSFER_VALIDATION_FUNCTION_SIGNATURE;
        isViewFunction = true;
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @dev Sets the transfer validator.
    /// @param validator The address of the transfer validator contract.
    /// @notice Passing `address(0)` removes the current transfer validator.
    function _setTransferValidator(address validator) internal {
        emit TransferValidatorUpdated(address(_transferValidator), validator);
        _transferValidator = ITransferValidator721(validator);
    }
}