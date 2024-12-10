// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "lib/solady/src/tokens/ERC721.sol";
import {ERC2981} from "lib/solady/src/tokens/ERC2981.sol";
import {Ownable} from "lib/solady/src/auth/Ownable.sol";
import {ERC721TransferValidator} from "../extensions/ERC721TransferValidator.sol";

/**
 * @title  ERC721C
 * @author 0xkuwabatake(@0xkuwabatake)
 * @notice A Simple ERC721-based implementation contract example that applies
 *         creator fee enforcement based on OpenSea Creator Fee Enforcement doc:
 *         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
 * @dev
 * - The contract does NOT inherit to ERC721C by LimitBreak:
 *   https://github.com/limitbreakinc/creator-token-contracts/blob/main/contracts/erc721c/ERC721C.sol
 * - The contract also inherits to ERC2981 - NFT Royalty Standard:
 *   https://eips.ethereum.org/EIPS/eip-2981 
 * - It is optional to call {ERC721TransferValidator - _setTransferValidator}
 *   and {ERC2981 - _setDefaultRoyalty} inside the constructor.
 * - Do NOT copy anything here into production code unless you really know what you are doing.
 */
contract ERC721C is ERC721, ERC2981, ERC721TransferValidator, Ownable {

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        _initializeOwner(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                        EXTERNAL FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @dev Mint `tokenId` to `msg.sender`.
    function mint(uint256 tokenId) external {
        _mint(msg.sender, tokenId);
    }

    /*//////////////////////////////////////////////////////////////
                    EXTERNAL ONLY OWNER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev Sets the default royalty `receiver` and `feeNumerator`.
    /// @custom:note Ref: https://github.com/Vectorized/solady/blob/main/src/tokens/ERC2981.sol#L99
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    /// @dev Sets transfer `validator` contract.
    /// @custom:note See: {ICreatorToken - setTransferValidator}.
    function setTransferValidator(address validator) external onlyOwner {
        _setTransferValidator(validator);
    }

    /*//////////////////////////////////////////////////////////////
                        PUBLIC VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns true if this contract implements the interface defined by `interfaceId`.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC2981, ERC721)
        returns (bool result)
    {
        return interfaceId == INTERFACE_ID_ICREATORTOKEN // Interface ID for ICreatorToken
            || interfaceId == 0x2a55205a // Interface ID for ERC2981
            || ERC721.supportsInterface(interfaceId);
    }

    /// @dev Returns the token collection name.
    function name() public view virtual override returns (string memory) {
        return "ERC721C";
    }

    /// @dev Returns the token collection symbol.
    function symbol() public view virtual override returns (string memory) {
        return "721-C";
    }

    /// @dev See: {ERC721 - tokenURI}.
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert TokenDoesNotExist();
        return "ipfs://QmQjJQWmr6yAHF2X8JM2TFwahFFFWG7Nqm7jxE35Mojs9b";
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @dev  Overriden {ERC721 - _beforeTokenTransfer} hook to facilitate transfer validation.
    /// Note: The NFT contract should implement one of the following transfer validation functions 
    ///       in their _beforeTokenTransfer hook, with the call being performed to 
    ///       the assigned transfer validator (if one is set).
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        virtual
        override
    {
        if (from != address(0) && to != address(0)) {
            address transferValidator = address(_transferValidator);
            // Call the transfer validator if `validator` is not zero address
            if (transferValidator != address(0)) {
                _transferValidator.validateTransfer(
                    msg.sender,
                    from,
                    to,
                    tokenId
                );
            }
        }
    }
}