// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Greeter.sol";

contract GreeterTest is DSTest {
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
}
