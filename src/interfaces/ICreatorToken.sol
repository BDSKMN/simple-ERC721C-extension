// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title  ICreatorToken
/// @author BDSKMN (@BDSKMN)
/// @notice Interface for a minimal creator token standard, allowing integration with 
///         OpenSea's creator fee enforcement. 
/// @dev    Reference:
///         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
interface ICreatorToken {
    /// @dev Emitted when the transfer `validator` contract address is updated.
    /// @param oldValidator The previous validator contract address.
    /// @param newValidator The new validator contract address.
    event TransferValidatorUpdated(address oldValidator, address newValidator);

    /// @dev Retrieves the current transfer validator contract address.
    /// @return validator The address of the current transfer validator contract.
    function getTransferValidator() external view returns (address validator);

    /// @dev Retrieves information about the transfer validation function.
    /// @return functionSignature The selector of the implemented validation function.
    /// @return isViewFunction Indicates whether the validation function is a view function.
    function getTransferValidationFunction() 
        external
        view
        returns (bytes4 functionSignature, bool isViewFunction);

    /// @dev Updates the transfer validator contract address.
    /// @param validator The address of the new validator contract.
    function setTransferValidator(address validator) external;
}