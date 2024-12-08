// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title  ITransferValidator721
 * @author 0xkuwabatake (0xkuwabatake)
 * @author Modified from ProjectOpenSea/seadrop/src/interfaces:
 *         https://github.com/ProjectOpenSea/seadrop/blob/main/src/interfaces/ITransferValidator.sol
 * @notice Transfer validator interface for ERC721
 */
interface ITransferValidator721 {
    /// @dev Ensure that a transfer has been authorized for a specific `tokenId` by the `caller` from `from` to `to.
    function validateTransfer(address caller, address from, address to, uint256 tokenId) external view;
}