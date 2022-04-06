// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import "../FizzBuzz.sol";

contract FizzBuzzTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    }

    function test_returns_fizz_when_divisible_by_three() public {
        assertEq(fizzbuzz.fizzbuzz(3), "fizz");
        assertEq(fizzbuzz.fizzbuzz(6), "fizz");
        assertEq(fizzbuzz.fizzbuzz(27), "fizz");
    }
    
    function test_returns_buzz_when_divisible_by_five() public {
        assertEq(fizzbuzz.fizzbuzz(5), "buzz");
        assertEq(fizzbuzz.fizzbuzz(10), "buzz");
        assertEq(fizzbuzz.fizzbuzz(175), "buzz");
    }

    function test_returns_fizzbuzz_when_divisible_by_three_and_five() public {
        assertEq(fizzbuzz.fizzbuzz(15), "fizzbuzz");
        assertEq(fizzbuzz.fizzbuzz(30), "fizzbuzz");
        assertEq(fizzbuzz.fizzbuzz(435), "fizzbuzz");
    }

    function test_returns_number_as_string_otherwise() public {
        assertEq(fizzbuzz.fizzbuzz(2), "2");
        assertEq(fizzbuzz.fizzbuzz(17), "17");
        assertEq(fizzbuzz.fizzbuzz(932), "932");
    }
}
contract FizzBuzzPropertyBasedTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    }

    function test_returns_fizz_when_divisible_by_three(uint256 n) public {
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 != 0);
        assertEq(fizzbuzz.fizzbuzz(n), "fizz");
    }
    
    function test_returns_buzz_when_divisible_by_five(uint256 n) public {
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 == 0);
        assertEq(fizzbuzz.fizzbuzz(n), "buzz");
    }

    function test_returns_fizzbuzz_when_divisible_by_three_and_five(uint256 n) public {
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 == 0);
        assertEq(fizzbuzz.fizzbuzz(n), "fizzbuzz");
    }

    function test_returns_number_as_string_otherwise(uint256 n) public {
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 != 0);
        assertEq(fizzbuzz.fizzbuzz(n), Strings.toString(n));
    }
}
