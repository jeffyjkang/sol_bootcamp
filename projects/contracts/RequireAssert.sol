// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract RequireAndAssert {
  mapping (address => uint8) public balanceReceived;

  function receiveMoney() public payable {
    assert(msg.value == uint8(msg.value));
    balanceReceived[msg.sender] += uint8(msg.value);
  }

  function withdrawMoney(address payable _to, uint8 _amount) public {
    // if (_amount <= balanceReceived[msg.sender]) {
    //   balanceReceived[msg.sender] -= _amount;
    //   _to.transfer(_amount);
    // }
    require(_amount <= balanceReceived[msg.sender], 'Not enough funds');
    balanceReceived[msg.sender] -= _amount;
    _to.transfer(_amount);
  }
}