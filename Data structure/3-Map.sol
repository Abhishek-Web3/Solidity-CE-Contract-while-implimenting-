// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Mapping {
    mapping(address => uint) public balances;

    function setBalances(uint _bal) public {
        balances[msg.sender] = _bal;
    }

    function getbalance(address _address) public view returns (uint) {
        return balances[_address];
    }
}