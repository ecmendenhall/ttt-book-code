// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";

import "../TicTacToken.sol";

contract TicTacTokenTest is DSTest {
    TicTacToken internal ttt;

    function setUp() public {
        ttt = new TicTacToken();
    }

    function test_has_empty_board() public {
        for (uint256 i=0; i<9; i++) {
            assertEq(ttt.board(i), "");
        }
    }
    function test_get_board() public {
        string[9] memory expected = ["", "", "", "", "", "", "", "", ""];
        string[9] memory actual = ttt.getBoard();

        for (uint256 i=0; i<9; i++) {
            assertEq(actual[i], expected[i]);
        }
    }

    function test_can_mark_space_with_X() public {
        ttt.markSpace(0, "X");
        assertEq(ttt.board(0), "X");
    }
    
    function test_can_mark_space_with_O() public {
        ttt.markSpace(0, "O");
        assertEq(ttt.board(0), "O");
    }
}
