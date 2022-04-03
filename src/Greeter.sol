// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

contract Greeter {
    string public greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        return _buildGreeting("world");
    }

    function greet(string memory name) public view returns (string memory) {
        return _buildGreeting(name);
    }

    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    function _buildGreeting(string memory name) internal view returns (string memory) {
        return string(abi.encodePacked(greeting, ", ", name, "!"));
    }
}
