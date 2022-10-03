// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Wallet {
  PaymentReceived public payment;

  function payContract() public payable {
    payment = new PaymentReceived(msg.sender, msg.value);
  }

}

contract PaymentReceived {
  address public from;
  uint public amount;
  constructor (address _from, uint _amount) {
    from = _from;
    amount = _amount;
  }
}

// usually less gas
contract Wallet2 {
  struct PaymentReceivedStruct {
    address from;
    uint amount;
  }
  PaymentReceivedStruct public payment;
  function payContract() public payable {
    // payment = PaymentReceivedStruct(msg.sender, msg.value);
    payment.from = msg.sender;
    payment.amount = msg.value;
  }
}

contract WalletMapping {
  struct Transaction {
    uint amount;
    uint timestamp;
  }

  struct Balance {
    uint totalBalance;
    uint numDeposits;
    mapping (uint => Transaction) deposits;
    uint numWithdrawals;
    mapping (uint => Transaction) withdrawals;
  }

  mapping (address => Balance) public balances;

  function getDepositNum(address _from, uint _numDeposit) public view returns (Transaction memory) {
    return balances[_from].deposits[_numDeposit];
  }

  function depositMoney() public payable {
    balances[msg.sender].totalBalance += msg.value;
    Transaction memory deposit = Transaction(msg.value, block.timestamp);
    balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
    balances[msg.sender].numDeposits++;
  }

  function withdrawMoney(address payable _to, uint _amount) public {
    balances[msg.sender].totalBalance -= _amount;
    Transaction memory withdrawal = Transaction(_amount, block.timestamp);
    balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;
    balances[msg.sender].numWithdrawals++;
    _to.transfer(_amount);
  }
}