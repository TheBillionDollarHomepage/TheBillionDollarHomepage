pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {BillionDollarCanvas} from "../src/BillionDollarCanvas.sol";

contract BillionDollarCanvasTest is Test {

  BillionDollarCanvas billionDollarCanvas;

  function setUp() public {
    address payable gitcoinAddress = payable(address(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F));
    billionDollarCanvas = new BillionDollarCanvas(gitcoinAddress, 1 wei);
  }

  function test_buy() public {
    vm.prank(address(1));
    vm.deal(address(1), 1 ether);
    billionDollarCanvas.buy{value: 1 wei}(13, "https://bafybeidjjog7rbuhcsfpmb5nt2jrilpwt6bm64ubquxqpakswiks56f2mu.ipfs.w3s.link/index.jpeg");
    assertEq(billionDollarCanvas.ownerOf(13), address(1));
    assertEq(billionDollarCanvas.balanceOf(address(1)), 1);
  }
}
