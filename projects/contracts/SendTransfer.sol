// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Sender {
  receive() external payable {}

  function withdrawTransfer(address payable _to) public {
    _to.transfer(10); // throws error when transfer fails
  }

  function withdrawSend(address payable _to) public {
    // _to.send(10); // returns boolean
    bool isSent = _to.send(10);
    require(isSent, 'Sending the funds was unsuccessful');
  }
}

contract ReceiverNoAction {
  function balance() public view returns(uint) {
    return address(this).balance;
  }

  receive() external payable {}
}

contract ReceiverAction {
  uint public balanceReceived;

  receive() external payable {
    balanceReceived += msg.value;
  }

  function balance() public view returns(uint) {
    return address(this).balance;
  }
}

contract ContractOne {
  mapping(address => uint) public addressBalances;

  function deposit() public payable {
    addressBalances[msg.sender] += msg.value;
  }

  receive() external payable {
    deposit();
  }
}

contract ContractTwo {
  receive() external payable {}

  function depositOnContractOne(address _contractOne) public {
    // ContractOne one = ContractOne(_contractOne);
    // one.deposit{value: 10, gas: 100000}();

    // bytes memory payload = abi.encodeWithSignature("deposit()");
    // (bool success, ) = _contractOne.call{value: 10, gas: 100000}(payload);
    // require(success);

    // unknown function, low level call
    (bool success, ) = _contractOne.call{value: 10, gas: 100000}("");
    require(success);
  }
}
// possible reentrancy attacks
