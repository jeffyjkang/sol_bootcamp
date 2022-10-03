// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract StartStopUpdate {
  receive() external payable {}

  function destroySmartContract() public {
    selfdestruct(payable(msg.sender));
  }
}

// gotcha ** a deployed contract that has 'self-destructed' can still receive eth, just no functionality attached to it, sol lost in the 'ether' **
// however also a way to re-deploy contract on same address
