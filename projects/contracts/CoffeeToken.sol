// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CoffeeToken is ERC20, AccessControl {
  bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');

  event CoffeePurchased(address indexed receiver, address indexed buyer);

  constructor() ERC20("CoffeeToken", "CFE") {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(MINTER_ROLE, msg.sender);
  }

  function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
    _mint(_to, _amount * 10 ** decimals());
  }

  function buyOneCoffee() public {
    _burn(_msgSender(), 1 * 10 ** decimals());
    emit CoffeePurchased(_msgSender(), _msgSender());
  }

  function buyOneCoffeeFrom(address _account) public {
    _spendAllowance(_account, _msgSender(), 1 * 10 ** decimals());
    _burn(_account, 1 * 10 ** decimals());
    emit CoffeePurchased(_msgSender(), _account);
  }
}
