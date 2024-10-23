// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract OurToken is ERC20, ERC20Burnable {
    constructor() ERC20("OurToken", "OTK") {
        _mint(msg.sender, 1000 ether); // Initial mint
    }
}