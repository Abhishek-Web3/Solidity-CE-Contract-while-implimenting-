// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "./Library.sol";

contract Sum {
    function sumFunc(uint a , uint b) external pure returns(uint) {
        return Addition.addfunc(a,b);
    }
}