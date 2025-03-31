// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title  ITransferValidator721
/// @author BDSKMN (@BDSKMN)
///         Modified from ProjectOpenSea/seadrop:
///         https://github.com/ProjectOpenSea/seadrop/blob/main/src/interfaces/ITransferValidator.sol
/// @notice Interface for validating ERC721 token transfers.
interface ITransferValidator721 {
    /// @dev Validates if `caller` is authorized to transfer `tokenId` from `from` to `to`.
    /// @param caller The initiator of the transfer.
    /// @param from The current owner of the token.
    /// @param to The recipient of the token.
    /// @param tokenId The token ID being transferred.
    function validateTransfer(address caller, address from, address to, uint256 tokenId) external view;
}