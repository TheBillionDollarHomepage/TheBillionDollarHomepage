// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// @custom:security-contact smuu.eth@proton.me
contract BillionDollarCanvas is ERC721, ERC721Enumerable, ERC721URIStorage {

  // gitcoinAddress
  address payable _gitcoinAddress;

  // Inital canvas price in wei
  uint256 _initPrice;

  // Mapping from token ID to canvas Price
  mapping(uint256 => uint256) private _canvasIdToCanvasPrice;

  event MintCanvas(
    uint256 canvasId,
    address owner
  );

  event BuyCanvas(
    uint256 canvasId,
    address oldOwner,
    address newOwner
  );

  event AuctionCanvas(
    uint256 canvasId,
    address oldOwner
  );

  event ChangePrice(
    uint256 canvasId,
    uint256 oldPrice,
    uint256 newPrice
  );

  event ChangeCanvasURI(
    uint256 canvasId,
    string oldCanvasURI,
    string newCanvasURI
  );

  constructor(address payable gitcoinAddress, uint256 initPrice) ERC721("BillionDollarCanvas", "BDC") {
    _gitcoinAddress = gitcoinAddress;
    _initPrice = initPrice;
  }

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

  //// Own provided functions

  modifier onlyCanvasOwner(uint256 canvasId) {
    require(_ownerOf(canvasId) == address(0), "You don't own this canvas");
    _;
  }

  function setCanvasURI(uint256 canvasId, string memory uri)
    public
    onlyCanvasOwner(canvasId)
  {
    if (keccak256(abi.encodePacked(tokenURI(canvasId))) != keccak256(abi.encodePacked(uri))) {
      emit ChangeCanvasURI(canvasId, tokenURI(canvasId), uri);
      _setTokenURI(canvasId, uri);
    }
  }

  // Get price of a canvas
  function priceOf(uint256 canvasId) public view returns (uint256) {
    // If a canvas has no owner return the init price
    if (_ownerOf(canvasId) == address(0)) {
      return _initPrice;
    }
    // return the current canvas price
    return _canvasIdToCanvasPrice[canvasId];
  }

  // Set price of canvas
  function setPrice(uint256 canvasId, uint256 price)
    public
    onlyCanvasOwner(canvasId)
  {
    require(_ownerOf(canvasId) == address(0), "You don't own this canvas");
    if (_canvasIdToCanvasPrice[canvasId] != price) {
      emit ChangePrice(canvasId, _canvasIdToCanvasPrice[canvasId], price);
      _canvasIdToCanvasPrice[canvasId] = price;
    }
  }

  // Everybody can mint
  function buy(uint256 canvasId, string memory uri, uint256 price)
    public
    payable
  {
    uint256 currentPrice = priceOf(canvasId);
    require(_ownerOf(canvasId) != msg.sender, "You already own this canvas");
    require(msg.value >= currentPrice, "Not enough wei provided");

    address payable currentOwner = payable(_ownerOf(canvasId));

    if (currentOwner == address(0))
    // if canvas is not owned yet send tx value to gitcoin
    {
      _gitcoinAddress.transfer(msg.value);
      _safeMint(msg.sender, canvasId);
      emit MintCanvas(canvasId, msg.sender);
    }
    else
    // if canvas is owned, send tx value to old owner
    {
      // FIXME: Not save this way! Instead use withdrawal function
      currentOwner.transfer(msg.value);
      emit BuyCanvas(canvasId, currentOwner, msg.sender);
    }

    setPrice(canvasId, price);

    setCanvasURI(canvasId, uri);
  }
}
