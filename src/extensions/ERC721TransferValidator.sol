// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ICreatorToken} from "../interfaces/ICreatorToken.sol";
import {ITransferValidator721} from "../interfaces/ITransferValidator721.sol";

/**
 * @title  ERC721TransferValidator
 * @author 0xkuwabatake(@0xkuwabatake)
 * @author Modified from ProjectOpenSea/seadrop/src/lib:
 *         https://github.com/ProjectOpenSea/seadrop/blob/main/src/lib/ERC721TransferValidator.sol
 * @notice ERC721 Contract extension for specific ERC721 validation transfer.
 * @dev    The contract is intended to be inherited by ERC721-based implementation contract
 *         that applies creator fee enforcement based on OpenSea doc:
 *         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard 
 */
abstract contract ERC721TransferValidator is ICreatorToken {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Transfer validation function signature for ERC721.
    /// @custom:note Ref: https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
    bytes4 private constant _ERC721_TRANSFER_VALIDATION_FUNCTION_SIGNATURE = 0xcaee23ea;

    /// @dev Interface ID for ICreatorToken.
    /// @custom:note bytes4((type(ICreatorToken).interfaceId))
    bytes4 internal constant INTERFACE_ID_ICREATORTOKEN = 0xad0d7f6c;

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev Transfer validator address to interact with {ITransferValidator721}.
    ITransferValidator721 internal _transferValidator;

    /*//////////////////////////////////////////////////////////////
                        PUBLIC VIEW FUNCTIONS
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

    /**
     * @dev Sets `validator` as transfer validator internal.
     * @param validator Transfer validator contract.
     * @custom:notes
     * - The external method to call this function must include access control.
     * - Sets `validator` to address zero means no transfer validator is set.
     */
    function _setTransferValidator(address validator) internal {
        emit TransferValidatorUpdated(address(_transferValidator), validator);
        _transferValidator = ITransferValidator721(validator);
    }
}