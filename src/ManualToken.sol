// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract ManualToken {

    mapping (address => uint256) private s_balances;
    function name() public pure returns (string memory) {
        return "Manual Token";
        
    }
    function totalSupply() public pure returns (uint256) {
        return 100 ether; //
    }
    function decimals() public pure returns (uint8) {
        return 18;
    }
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balances[_owner];

    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(s_balances[msg.sender] >= _value);
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        return true;
    }
}