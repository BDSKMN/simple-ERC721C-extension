// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
        
/**
 * @title  ICreatorToken
 * @author 0xkuwabatake (@0xkuwabatake)
 * @notice Minimal creator token standard interface based on: 
 *         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
 */
interface ICreatorToken {
    /// @dev Emitted when `newValidator` contract is updated from `oldValidator` contract.
    event TransferValidatorUpdated(address oldValidator, address newValidator);


    /// @dev Returns recent transfer `validator` contract address.
    /// @custom:note The zero address means no transfer validator is set.
    function getTransferValidator() external view returns (address validator);

    /// @dev Returns `functionSignature` and `isViewFunction` from implemented transfer validation function.
    function getTransferValidationFunction() 
        external
        view
        returns (bytes4 functionSignature, bool isViewFunction);

    /// @dev Sets transfer `validator` contract.
    function setTransferValidator(address validator) external;
}