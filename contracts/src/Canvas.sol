// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// @custom:security-contact smuu.eth@proton.me
contract BillionDollarCanvas is ERC721, ERC721Enumerable, ERC721URIStorage {
  constructor() ERC721("BillionDollarCanvas", "BDC") {}

  // The following functions are overrides required by Solidity.

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function _beforeConsecutiveTokenTransfer(address from, address to, uint256 first, uint96 size)
    internal
    override(ERC721, ERC721Enumerable)
  {
    super._beforeConsecutiveTokenTransfer(from, to, first, size);
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return super.tokenURI(tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
