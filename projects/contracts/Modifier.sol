// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import './Ownable.sol';

contract Modifier is Owner {
  mapping (address => uint) public tokenBalance;
  uint tokenPrice = 1 ether;
  constructor() {
    tokenBalance[msg.sender] = 100;
  }

  function createNewToken() public onlyOwner {
    tokenBalance[owner]++;
  }

  function burnToken() public onlyOwner {
    tokenBalance[owner]--;
  }

  function purchaseToken() public payable {
    require((tokenBalance[owner] * tokenPrice)/ msg.value > 0, 'Not enough tokens to purchase');
    tokenBalance[owner] -= msg.value / tokenPrice;
    tokenBalance[msg.sender] += msg.value / tokenPrice;
  }

  function sendToken(address _to, uint _amount) public {
    require(tokenBalance[msg.sender] >= _amount, 'Not enough tokens to send');
    tokenBalance[msg.sender] -= _amount;
    tokenBalance[_to] += _amount;
  }

}
