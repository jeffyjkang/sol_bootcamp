// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Consumer {
  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  function deposit() public payable {}
}

contract SmartWallet {
  address payable public owner;
  mapping(address => uint) public allowance;
  mapping(address => bool) public isAllowedToSend;
  mapping(address => bool) public guardians;
  mapping(address => mapping(address => bool)) nextOwnerGuardianDidVote;
  address payable nextOwner;
  uint guardiansResetCount;
  uint public constant confirmationsFromGuardiansForReset = 3;

  constructor() {
    owner = payable(msg.sender);
  }

  function setGuardian(address _guardian, bool _isGuardian) public {
    require(msg.sender == owner, 'Must be owner to set guardian');
    guardians[_guardian] = _isGuardian;
  }

  function proposeNewOwner(address payable _newOwner) public {
    require(guardians[msg.sender], 'You must be a guardian to propose new owner');
    require(nextOwnerGuardianDidVote[_newOwner][msg.sender] == false, 'You cannot vote twice');
    if (_newOwner != nextOwner) {
      nextOwner = _newOwner;
      guardiansResetCount = 0;
    }
    guardiansResetCount++;
    if (guardiansResetCount >= confirmationsFromGuardiansForReset) {
      owner = nextOwner;
      nextOwner = payable(address(0));
    }
  }

  function setAllowance(address _for, uint _amount) public {
    require(msg.sender == owner, 'Must be owner to set allowance');
    allowance[_for] = _amount;

    if (_amount > 0) {
      isAllowedToSend[_for] = true;
    } else {
      isAllowedToSend[_for] = false;
    }
  }

  function transfer(address payable _to, uint _amount, bytes calldata _payload) public returns(bytes memory) {
    // require(msg.sender == owner, 'You are not the owner, aborting');
    if (msg.sender != owner) {
      require(isAllowedToSend[msg.sender], 'You are not allowed to transfer');
      require(allowance[msg.sender] >= _amount, 'Amount exceeds allowance amount');
      allowance[msg.sender] -= _amount;
    }

    (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
    require(success, 'Aborting call was not successful');
    return returnData;
  }

  receive() external payable {}
}

// this contract needs revisions, guardian vote?
