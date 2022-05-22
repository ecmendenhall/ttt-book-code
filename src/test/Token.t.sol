// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../Token.sol";

contract TicTacTokenTest is DSTest {
    Vm internal vm = Vm(HEVM_ADDRESS);

    Token internal token;

    function setUp() public {
        token = new Token();
    }

    function test_token_name() public {
        assertEq(token.name(), "Tic Tac Token");
    }

    function test_token_symbol() public {
        assertEq(token.symbol(), "TTT");
    }

    function test_token_decimals() public {
        assertEq(token.decimals(), 18);
    }

    function test_mint_to_user() public {
        token.mint(address(this), 100 ether);
        assertEq(token.balanceOf(address(this)), 100 ether);
    }

    function test_transfer_tokens() public {
        token.mint(address(this), 100 ether);
        token.transfer(address(42), 50 ether);

        assertEq(token.balanceOf(address(this)), 50 ether);
        assertEq(token.balanceOf(address(42)), 50 ether);
    }

    function test_non_owner_cannot_mint() public {
        vm.prank(address(42));
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(address(this), 100 ether);
    }

}
