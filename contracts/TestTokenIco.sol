// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./TestToken.sol";

contract TokenICO is Token {
    address public owner;
    address payable public deppositAddress;
    uint256 tokenPrice = 0.0001 ether;
    uint256 hardCap = 50 ether;
    uint256 public raisedAmount;

    // ICO Start/End
    uint256 public saleStart = block.timestamp;
    uint256 public saleEnd = block.timestamp + 604800; // sale ends one week after starting
}
