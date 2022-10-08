pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {BillionDollarCanvas} from "../src/BillionDollarCanvas.sol";

contract BillionDollarCanvasTest is Test {

  BillionDollarCanvas billionDollarCanvas;

  string tokenURI1 = "https://bafybeidjjog7rbuhcsfpmb5nt2jrilpwt6bm64ubquxqpakswiks56f2mu.ipfs.w3s.link/index.jpeg";
  string tokenURI2 = "https://bafybeidjjog7rbuhcsfpmb5nt2jrilpwt6bm64ubquxqpakswiks56f2mu.ipfs.w3s.link/index.jpeg";

  uint256 canvasIdCounter;

  function setUp() public {
    address payable gitcoinAddress = payable(address(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F));
    billionDollarCanvas = new BillionDollarCanvas(gitcoinAddress, 1 wei, 225);
    canvasIdCounter = 0;

    vm.deal(address(1), 100 ether);
    vm.deal(address(2), 100 ether);
    vm.deal(address(3), 100 ether);
  }

  function test_buy() public {
    canvasIdCounter = canvasIdCounter + 1;
    vm.prank(address(1));
    billionDollarCanvas.buy{value: 1 wei}(canvasIdCounter, tokenURI1, 1);
    assertEq(billionDollarCanvas.ownerOf(canvasIdCounter), address(1));
    assertEq(billionDollarCanvas.balanceOf(address(1)), 1);
  }

  function test_buy_twice_the_same() public {
    canvasIdCounter = canvasIdCounter + 1;
    vm.prank(address(1));
    billionDollarCanvas.buy{value: 1 wei}(canvasIdCounter, tokenURI1, 1);
    vm.expectRevert(bytes("You already own this canvas"));
    vm.prank(address(1));
    billionDollarCanvas.buy{value: 1 wei}(canvasIdCounter, tokenURI1, 1);
  }

  function test_buy_not_enough_value() public {
    canvasIdCounter = canvasIdCounter + 1;
    vm.expectRevert(bytes("Not enough wei provided"));
    vm.prank(address(1));
    billionDollarCanvas.buy{value: 0 wei}(canvasIdCounter, tokenURI1, 1);
  }

  function test_buy_and_buy() public {
    canvasIdCounter = canvasIdCounter + 1;
    uint256 price = 5 wei;
    vm.prank(address(2));
    billionDollarCanvas.buy{value: 1 wei}(canvasIdCounter, tokenURI1, price);
    uint256 balance_old = address(2).balance;
    vm.prank(address(3));
    billionDollarCanvas.buy{value: price}(canvasIdCounter, tokenURI2, 10);
    uint256 balance_new = address(2).balance;
    assertEq(balance_new - balance_old, price);
  }
}
