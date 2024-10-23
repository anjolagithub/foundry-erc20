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
    address charlie = makeAddr("charlie");

    uint256 public constant STARTING_BALANCE = 1000 ether;
    uint256 public constant TRANSFER_AMOUNT = 100 ether;

    // Declare the Approval and Transfer events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        deployOurToken = new DeployOurToken();
        ourTokenInstance = deployOurToken.run();

        // Give Bob some tokens to start with
        vm.prank(address(deployOurToken));
        ourTokenInstance.transfer(bob, TRANSFER_AMOUNT);
    }

    // Test initial balances
    function testBalanceOf() public {
        assertEq(ourTokenInstance.balanceOf(bob), TRANSFER_AMOUNT);
        assertEq(ourTokenInstance.balanceOf(alice), 0);
        assertEq(ourTokenInstance.balanceOf(charlie), 0);
    }

    // Test token transfer between accounts
    function testTransfer() public {
        vm.prank(bob);
        ourTokenInstance.transfer(alice, 50 ether);
        assertEq(ourTokenInstance.balanceOf(alice), 50 ether);
        assertEq(ourTokenInstance.balanceOf(bob), 50 ether);
    }

    // Test failure when transferring more tokens than balance
    function testTransferInsufficientBalance() public {
        vm.expectRevert(); // Should revert since Bob only has 100 ether
        vm.prank(bob);
        ourTokenInstance.transfer(alice, 200 ether);
    }

    // Test allowances and approvals
    function testAllowance() public {
        assertEq(ourTokenInstance.allowance(bob, alice), 0);

        vm.prank(bob);
        ourTokenInstance.approve(alice, 50 ether);

        assertEq(ourTokenInstance.allowance(bob, alice), 50 ether);
    }

    // Test transferFrom using allowances
    function testTransferFromWithAllowance() public {
        vm.prank(bob);
        ourTokenInstance.approve(alice, 50 ether);

        vm.prank(alice);
        ourTokenInstance.transferFrom(bob, charlie, 50 ether);

        assertEq(ourTokenInstance.balanceOf(charlie), 50 ether);
        assertEq(ourTokenInstance.balanceOf(bob), 50 ether);
    }

    // Test transferFrom exceeding approved allowance
    function testTransferFromExceedsAllowance() public {
        vm.prank(bob);
        ourTokenInstance.approve(alice, 50 ether);

        vm.expectRevert(); // Expect revert as alice only has approval for 50 ether
        vm.prank(alice);
        ourTokenInstance.transferFrom(bob, charlie, 100 ether);
    }

    // Test approve failure case where trying to approve more than the balance
    function testApproveInsufficientBalance() public {
        vm.prank(bob);
        vm.expectRevert(); // Bob only has 100 ether
        ourTokenInstance.approve(alice, 200 ether);
    }

    // Test token's total supply
    function testTotalSupply() public {
        assertEq(ourTokenInstance.totalSupply(), STARTING_BALANCE);
    }

    // Test token's decimal value
    function testDecimals() public {
        assertEq(ourTokenInstance.decimals(), 18);
    }

    // Test if the transfer event is emitted
    function testTransferEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, 50 ether); // Expect a Transfer event to be emitted

        ourTokenInstance.transfer(alice, 50 ether);
    }

    // Test if the approval event is emitted
    function testApprovalEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, 50 ether); // Expect an Approval event to be emitted

        ourTokenInstance.approve(alice, 50 ether);
    }

    // Test the burn function if applicable
    function testBurn() public {
        uint256 initialSupply = ourTokenInstance.totalSupply();

        vm.prank(bob);
        ourTokenInstance.burn(10 ether);

        assertEq(ourTokenInstance.totalSupply(), initialSupply - 10 ether);
        assertEq(ourTokenInstance.balanceOf(bob), TRANSFER_AMOUNT - 10 ether);
    }

    // Test mint function if applicable
    function testMint() public {
        uint256 initialSupply = ourTokenInstance.totalSupply();

        vm.prank(address(deployOurToken));
        ourTokenInstance.mint(alice, 20 ether);

        assertEq(ourTokenInstance.totalSupply(), initialSupply + 20 ether);
        assertEq(ourTokenInstance.balanceOf(alice), 20 ether);
    }
}
