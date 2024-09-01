// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Assembly} from "../src/Assembly.sol";

contract AssemblyTest is Test {
  Assembly public assemblyCtrt;

  function setUp() public {
    assemblyCtrt = new Assembly();
  }

  function test_Increment() public {
    //assemblyCtrt.increment();
    //assertEq(assemblyCtrt.number(), 1);
  }
}
/*  function testFuzz1(uint256 x) public {
    assemblyCtrt.setNumber(x);
    assertEq(assemblyCtrt.number(), x);
  }
 */
