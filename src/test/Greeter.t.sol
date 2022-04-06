// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../Greeter.sol";

contract GreeterTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);

    Greeter internal greeter;

    function setUp() public {
        greeter = new Greeter("Hello");
    }

    function test_default_greeting() public {
       assertEq(greeter.greet(), "Hello, world!");
    }
    
    function test_custom_greeting() public {
       assertEq(greeter.greet("foundry"), "Hello, foundry!");
    }

    function test_get_greeting() public {
        assertEq(greeter.greeting(), "Hello");
    }
    
    function test_set_greeting() public {
        greeter.setGreeting("Ahoy-hoy");
        assertEq(greeter.greet(), "Ahoy-hoy, world!");
    }

    function test_non_owner_cannot_set_greeting() public {
        vm.prank(address(1));
        try greeter.setGreeting("Ahoy-hoy") {
            fail();
        } catch Error(string memory message) {
            assertEq(message, "Ownable: caller is not the owner");
        }
    }
}
