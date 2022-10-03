// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Owner {
  address owner;
  constructor () {
    owner = msg.sender;
  }
  modifier onlyOwner() {
    require(msg.sender == owner, 'You must be owner to execute');
    _;
  }
}
