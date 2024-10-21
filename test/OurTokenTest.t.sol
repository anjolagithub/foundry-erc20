// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourTokenInstance;
    DeployOurToken public deployOurToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;
   
    function setUp() public {
        deployOurToken = new DeployOurToken();
        ourTokenInstance = deployOurToken.run();

        vm.prank(address(deployOurToken));
        ourTokenInstance.transfer(bob, 100 ether);
    }

    function testBalanceOf() public view {
        assertEq(ourTokenInstance.balanceOf(bob), 100 ether);
        assertEq(ourTokenInstance.balanceOf(alice), 0);
    }

    function testAllowance() public {
    assertEq(ourTokenInstance.allowance(bob, alice), 0);
    vm.prank(bob);
    ourTokenInstance.approve(alice, 50 ether);

    uint256 transferAmount = 50 ether; // Ensure the transfer amount is within the approved allowance
    vm.prank(alice);
    ourTokenInstance.transferFrom(bob, alice, transferAmount);

    assertEq(ourTokenInstance.balanceOf(alice), transferAmount);
    assertEq(ourTokenInstance.balanceOf(bob), 0); // Assuming bob had 50 ether initially
}
    
        function testTotalSupply() public view {
            assertEq(ourTokenInstance.totalSupply(), STARTING_BALANCE);
        }
    
        function testDecimals() public view {
            assertEq(ourTokenInstance.decimals(), 18);
        }
}
