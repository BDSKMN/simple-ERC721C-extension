// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721A} from "lib/ERC721A/contracts/ERC721A.sol";
import {ERC2981} from "lib/solady/src/tokens/ERC2981.sol";
import {Ownable} from "lib/solady/src/auth/Ownable.sol";
import {ERC721TransferValidator} from "../extensions/ERC721TransferValidator.sol";

/**
 * @title  ERC721AC
 * @author 0xkuwabatake(@0xkuwabatake)
 * @notice A Simple ERC721A-based implementation contract example that demonstrates
 *         creator fee enforcement based on OpenSea Creator Fee Enforcement doc:
 *         https://docs.opensea.io/docs/creator-fee-enforcement#creator-token-standard
 * @dev
 * - The contract does NOT inherit to ERC721AC by LimitBreak:
 *   https://github.com/limitbreakinc/creator-token-contracts/blob/main/contracts/erc721c/ERC721AC.sol
 * - The contract also inherits to ERC2981 - NFT Royalty Standard:
 *   https://eips.ethereum.org/EIPS/eip-2981 
 * - It is optional to call {ERC721TransferValidator - _setTransferValidator}
 *   and {ERC2981 - _setDefaultRoyalty} inside the constructor.
 * - Do NOT copy anything here into production code unless you really know what you are doing.
 */
contract ERC721AC is ERC721A, ERC2981, ERC721TransferValidator, Ownable {

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() ERC721A("ERC721AC", "721A-C") {
        _initializeOwner(msg.sender);
        // See {ERC2981 - _setDefaultRoyalty}
        _setDefaultRoyalty(msg.sender, 100); // 1% royalty fee
        // See {ERC721TransferValidator - _setTransferValidator}
        // It sets to StrictAuthorizedTransferSecurityRegistry contract by OpenSea
        _setTransferValidator(0xA000027A9B2802E1ddf7000061001e5c005A0000);
    }

    /*//////////////////////////////////////////////////////////////
                        EXTERNAL FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @dev Mint `quantity` of token ID(s) to `msg.sender`.
    function mint(uint256 quantity) external {
        _mint(msg.sender, quantity);
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
        override(ERC2981, ERC721A)
        returns (bool result)
    {
        return interfaceId == INTERFACE_ID_ICREATORTOKEN // Interface ID for ICreatorToken
            || interfaceId == 0x2a55205a // Interface ID for ERC2981
            || ERC721A.supportsInterface(interfaceId);
    }

    /// @dev See: {ERC721A - tokenURI}.
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
        return "ipfs://QmQjJQWmr6yAHF2X8JM2TFwahFFFWG7Nqm7jxE35Mojs9b";
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @dev  Overriden {ERC721A - _beforeTokenTransfer} hook to facilitate transfer validation.
    /// Note: The NFT contract should implement one of the following transfer validation functions 
    ///       in their _beforeTokenTransfer hook, with the call being performed to 
    ///       the assigned transfer validator (if one is set).
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 /* quantity */
    ) internal virtual override {
        if (from != address(0) && to != address(0)) {
            address transferValidator = address(_transferValidator);
            // Call the transfer validator if `validator` is not zero address
            if (transferValidator != address(0)) {
                _transferValidator.validateTransfer(
                    msg.sender,
                    from,
                    to,
                    startTokenId
                );
            }
        }
    }
}