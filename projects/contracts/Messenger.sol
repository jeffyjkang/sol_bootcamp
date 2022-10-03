// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Messenger {
  uint public changeCounter;
  address public owner;
  string public theMessage;
  constructor() {
    owner = msg.sender;
  }
  function updateThemessage(string calldata _newMessage) public {
    if (msg.sender == owner) {
      theMessage = _newMessage;
      changeCounter++;
    }
  }
}
