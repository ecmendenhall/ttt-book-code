// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract FizzBuzz {

    function fizzbuzz(uint256 n) public pure returns (string memory) {
        if (n % 3 == 0 && n % 5 == 0) {
            return "fizzbuzz";
        }
        else if (n % 3 == 0) {
            return "fizz";
        }
        else if (n % 5 == 0) {
            return "buzz";
        } else {
            return Strings.toString(n);
        }
    }
}
