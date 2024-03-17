// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";
import "hardhat/console.sol";

contract ZVER is Permissioned {
  euint16[] private pubInputs;
  euint16[] private privInputs;
  euint16[] private pubConst;
  enum Instr {
    Add,
    Mul,
    PushPub,
    PushPriv,
    PushConst}

  Instr[] private program;
  uint256[] private programParams;

  euint16[] private stack;

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function reset() public {
    delete pubInputs; pubInputs = new euint16[](0);
    delete privInputs; privInputs = new euint16[](0);
    delete pubConst; pubConst = new euint16[](0);
    delete program; program = new Instr[](0);
    delete programParams; programParams = new uint256[](0);
    delete stack; stack = new euint16[](0);
  }

  function addInstr(Instr instr, uint256 param) public {
    program.push(instr);
    programParams.push(param);
  }

  function addPubInput(uint16 input) public {
    pubInputs.push(FHE.asEuint16(input));
  }

  function addPrivInput(inEuint16 calldata encryptedValue) public {
    privInputs.push(FHE.asEuint16(encryptedValue));
  }

  function addPubConst(uint16 input) public {
    pubConst.push(FHE.asEuint16(input));
  }

  function runZver() public {
    for (uint i = 0; i < program.length; i++) {
      if (program[i] == Instr.Add) {
        euint16 a = stack[stack.length-1];
        stack.pop();
        euint16 b = stack[stack.length-1];
        stack.pop();
        stack.push(a + b);
      } else if (program[i] == Instr.Mul) {
        euint16 a = stack[stack.length-1];
        stack.pop();
        euint16 b = stack[stack.length-1];
        stack.pop();
        stack.push(a * b);
      } else if (program[i] == Instr.PushConst) {
        stack.push(pubConst[programParams[i]]);
      } else if (program[i] == Instr.PushPriv) {
        stack.push(privInputs[programParams[i]]);
      } else if (program[i] == Instr.PushPub) {
        stack.push(pubInputs[programParams[i]]);
      }
     }
  }

  function getDecrVer() public view returns (uint16) {
    return FHE.decrypt(stack[stack.length - 1]);
  }

  // function getCounterPermit(
  //   Permission memory permission
  // ) public view onlySender(permission) returns (uint256) {
  //   return FHE.decrypt(counter);
  // }

  // function getCounterPermitSealed(
  //   Permission memory permission
  // ) public view onlySender(permission) returns (bytes memory) {
  //   return FHE.sealoutput(counter, permission.publicKey);
  // }

  // function testZver() public returns (uint16) {
  //   addPubConst(type(uint16).max - 10 + 1); // -10

  //   addInstr(Instr.PushConst, 0);
  //   addInstr(Instr.PushPriv, 0);
  //   addInstr(Instr.PushPriv, 1);
  //   addInstr(Instr.Mul, 0);
  //   addInstr(Instr.Add, 0);

  //   addPrivInput(FHE.asInEuint16(2));
  //   addPrivInput(FHE.asInEuint16(5));

  //   runZver();
  //   assert(getDecrVer() == 0);
  // }
}
