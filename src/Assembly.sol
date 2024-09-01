// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Language used for assembly is called Yul

contract Assembly {
  //declare and return a variable
  function yul_let() public pure returns (uint256 z) {
    assembly {
      let x := 123
      z := 456
    }
  }

  //------------== Conditional
  //if ... no else
  function yul_if(uint256 x) public pure returns (uint256 z) {
    assembly {
      // if condition = 1 { code }
      // no else... set a default value first
      // if 1 { z := 99 }
      if lt(x, 10) { z := 99 } //if x < 10, the condition will return 1, or the condition will return 0
    }
  }

  // switch
  function yul_switch(uint256 x) public pure returns (uint256 z) {
    assembly {
      switch x
      case 1 { z := 10 }
      case 2 { z := 20 }
      default { z := 0 }
    }
  }

  function yul_min(uint256 x, uint256 y) public pure returns (uint256 z) {
    z = y;
    assembly {
      if lt(x, y) { z := x }
    }
  }

  function yul_max(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      switch gt(x, y)
      case 1 { z := x }
      default { z := y }
    }
  }

  //------------== Error
  function yul_revert(uint256 x) public pure {
    assembly {
      // revert(p, s): end execution + revert state changes + return data mem[p…(p+s))... p is the start of the memoery, p+s is the end of the memory
      // revert(0, 0): returns no error message
      if gt(x, 10) { revert(0, 0) }
    }
  }

  //------------== Loops
  function yul_for_loop() public pure returns (uint256 z) {
    assembly {
      // for(uint i=0; i < 10; i++) { z += 1; }
      for { let i := 0 } lt(i, 10) { i := add(i, 1) } { z := add(z, 1) }
    }
  }

  function yul_while_loop() public pure returns (uint256 z) {
    assembly {
      let i := 0
      for {} lt(i, 5) {} {
        i := add(i, 1)
        z := add(z, 1)
      }
    }
  }

  //------------== Math
  function yul_sum_one_to_n_minus_1(uint256 n) public pure returns (uint256 z) {
    assembly {
      // for(uint i=1; i < n; i++) { z += i; }
      for { let i := 1 } lt(i, n) { i := add(i, 1) } { z := add(z, i) }
    }
  }

  /* Calculate x**n where n = 2**k
    x > 0, no overflow check
  expected: (2, 8) => 256
  expected: (2, 3) => error
  expected: (3, 4) => 81
  */
  function yul_pow2k(uint256 x, uint256 n) public pure returns (uint256 z) {
    require(x > 0, "x > 0");
    assembly {
      if mod(n, 2) { revert(0, 0) } //catch if n is not power of 2
      switch n
      case 0 { z := 1 }
      default { z := x }
      //only run when n != 0
      for {} lt(n, 1) {} {
        if mod(n, 2) { revert(0, 0) }
        z := mul(z, z)
        n := div(n, 2)
      }
    }
  }

  // Addition and Overflow
  function yul_add(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      z := add(x, y)
      if lt(z, x) { revert(0, 0) }
    }
  }

  // Substraction and Underflow
  function yul_sub(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      if lt(x, y) { revert(0, 0) }
      z := sub(x, y)
    }
  }

  // multiplication
  function yul_mul(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      switch x
      case 0 { z := 0 }
      default {
        z := mul(x, y)
        if iszero(eq(div(z, x), y)) { revert(0, 0) } // overflow. eq(a, b): returns 1 if a == b, else returns 0
      }
    }
  }

  // division
  function yul_div(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      if iszero(y) { revert(0, 0) }
      switch x
      case 0 { z := 0 }
      default { z := div(x, y) }
    }
  }

  // decimal calculation
  // Round to nearest multiple of b as base
  function yul_fixed_point_round(uint256 x, uint256 b) public pure returns (uint256 z) {
    assembly {
      // b = 100 ... as base
      let half := div(b, 2) // half = 50
      z := add(x, half)
      z := mul(div(z, b), b)
      // x = 90
      // z = 90 + 50 = 140
      // z = 140 / 100 * 100 = 100 ... rounded up

      // x = 49
      // z = 49 + 50 = 99
      // z = 99 / 100 * 100 = 0 ... omitted
    }
  }

  function yul_fixed_point_mul(uint256 x, uint256 y, uint256 b) public pure returns (uint256 z) {
    assembly {
      // b = 100 ... as base
      // 9 * 2 == 18 ... x = 900, y = 200
      // z = x * y / b = 1800

      //yul_mul() / b
      switch x
      case 0 { z := 0 }
      default {
        z := mul(x, y)
        if iszero(eq(div(z, x), y)) { revert(0, 0) }
        z := div(z, b)
      }
    }
  }
}
