// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract WillThrow {
  error NotAllowedError(string);

  function aFunctionRequire() public pure {
    require(false, "Error message");
  }
  function aFunctionAssert() public pure {
    assert(false);
  }
  function aFunction() public pure {
    revert NotAllowedError('You are not allowed');
  }
}

contract ErrorHandling {
  event ErrorLogging(string reason);
  event ErrorLogCode(uint code);
  event ErrorLogBytes(bytes lowLevelData);

  function catchTheRequrieError() public {
    WillThrow will = new WillThrow();
    try will.aFunctionRequire() {
      // add code here if it works
    } catch Error(string memory reason) {
      emit ErrorLogging(reason);
    }
  }
  function catchTheAssertError() public {
    WillThrow will = new WillThrow();
    try will.aFunctionAssert() {
      // add code here if it works
    } catch Panic(uint errorCode) {
      emit ErrorLogCode(errorCode);
    }
  }

  function catchError() public {
    WillThrow will = new WillThrow();
    try will.aFunction() {
      //
    } catch (bytes memory lowLevelData) {
      emit ErrorLogBytes(lowLevelData);
    }
  }
}
