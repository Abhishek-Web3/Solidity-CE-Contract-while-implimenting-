// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract mappingOfmappings {
    mapping (uint => mapping(uint => bool)) public data;
    function insert (uint row, uint col, bool value) public {
        data[row][col] = value;
    }
    function getData(uint row, uint col) public view returns (bool) {
        return data[row][col];
    }

}