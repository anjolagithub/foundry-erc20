// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply ) ERC20("Our Token", "OTK") {
        _mint(msg.sender, initialSupply);


    }
}