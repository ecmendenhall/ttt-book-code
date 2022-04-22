// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../TicTacToken.sol";

contract Caller {
    TicTacToken internal ttt;

    constructor(TicTacToken _ttt) {
        ttt = _ttt;
    }

    function call() public view returns (address) {
        return ttt.msgSender();
    }
}

contract User {

    TicTacToken internal ttt;
    Vm internal vm;
    address internal _address;

    constructor(address address_, TicTacToken _ttt, Vm _vm) {
        _address = address_;
        ttt = _ttt;
        vm = _vm;
    }

    function markSpace(uint256 space) public {
        vm.prank(_address);
        ttt.markSpace(space);
    }
}

contract TicTacTokenTest is DSTest {
    Vm internal vm = Vm(HEVM_ADDRESS);
    TicTacToken internal ttt;
    User internal playerX;
    User internal playerO;

    uint256 internal constant EMPTY = 0;
    uint256 internal constant X = 1;
    uint256 internal constant O = 2;

    address internal constant OWNER = address(1);
    address internal constant PLAYER_X = address(2);
    address internal constant PLAYER_O = address(3);

    function setUp() public {
        ttt = new TicTacToken(OWNER, PLAYER_X, PLAYER_O);
        playerX = new User(PLAYER_X, ttt, vm);
        playerO = new User(PLAYER_O, ttt, vm);
    }

    function test_has_empty_board() public {
        for (uint256 i = 0; i < 9; i++) {
            assertEq(ttt.board(i), EMPTY);
        }
    }

    function test_get_board() public {
        uint256[9] memory expected = [
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY
        ];
        uint256[9] memory actual = ttt.getBoard();

        for (uint256 i = 0; i < 9; i++) {
            assertEq(actual[i], expected[i]);
        }
    }

    function test_reset_board() public {
        playerX.markSpace(3);
        playerO.markSpace(0);
        playerX.markSpace(4);
        playerO.markSpace(1);
        playerX.markSpace(5);
        vm.prank(OWNER);
        ttt.resetBoard();
        uint256[9] memory expected = [
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY
        ];
        uint256[9] memory actual = ttt.getBoard();

        for (uint256 i = 0; i < 9; i++) {
            assertEq(actual[i], expected[i]);
        }
    }

    function test_can_mark_space_with_X() public {
        playerX.markSpace(0);
        assertEq(ttt.board(0), X);
    }

    function test_can_mark_space_with_O() public {
        playerX.markSpace(0);
        playerO.markSpace(1);
        assertEq(ttt.board(1), O);
    }

    function test_cannot_overwrite_marked_space() public {
        playerX.markSpace(0);

        vm.expectRevert("Already marked");
        playerO.markSpace(0);
    }

    function test_symbols_must_alternate() public {
        playerX.markSpace(0);
        vm.expectRevert("Not your turn");
        playerX.markSpace(1);
    }

    function test_tracks_current_turn() public {
        assertEq(ttt.currentTurn(), X);
        playerX.markSpace(0);
        assertEq(ttt.currentTurn(), O);
        playerO.markSpace(1);
        assertEq(ttt.currentTurn(), X);
    }

    function test_checks_for_horizontal_win() public {
        playerX.markSpace(0);
        playerO.markSpace(3);
        playerX.markSpace(1);
        playerO.markSpace(4);
        playerX.markSpace(2);
        assertEq(ttt.winner(), X);
    }

    function test_checks_for_horizontal_win_row2() public {
        playerX.markSpace(3);
        playerO.markSpace(0);
        playerX.markSpace(4);
        playerO.markSpace(1);
        playerX.markSpace(5);
        assertEq(ttt.winner(), X);
    }

    function test_checks_for_vertical_win() public {
        playerX.markSpace(1);
        playerO.markSpace(0);
        playerX.markSpace(2);
        playerO.markSpace(3);
        playerX.markSpace(4);
        playerO.markSpace(6);
        assertEq(ttt.winner(), O);
    }

    function test_checks_for_diagonal_win() public {
        playerX.markSpace(0);
        playerO.markSpace(1);
        playerX.markSpace(4);
        playerO.markSpace(5);
        playerX.markSpace(8);
        assertEq(ttt.winner(), X);
    }

    function test_checks_for_antidiagonal_win() public {
        playerX.markSpace(1);
        playerO.markSpace(2);
        playerX.markSpace(3);
        playerO.markSpace(4);
        playerX.markSpace(5);
        playerO.markSpace(6);
        assertEq(ttt.winner(), O);
    }

    function test_draw_returns_no_winner() public {
        playerX.markSpace(4);
        playerO.markSpace(0);
        playerX.markSpace(1);
        playerO.markSpace(7);
        playerX.markSpace(2);
        playerO.markSpace(6);
        playerX.markSpace(8);
        playerO.markSpace(5);
        assertEq(ttt.winner(), 0);
    }

    function test_empty_board_returns_no_winner() public {
        assertEq(ttt.winner(), 0);
    }

    function test_game_in_progress_returns_no_winner() public {
        playerX.markSpace(1);
        assertEq(ttt.winner(), 0);
    }

    function test_msg_sender() public {
        Caller caller1 = new Caller(ttt);
        Caller caller2 = new Caller(ttt);

        assertEq(ttt.msgSender(), address(this));

        assertEq(caller1.call(), address(caller1));
        assertEq(caller2.call(), address(caller2));
    }

    function test_contract_owner() public {
        assertEq(ttt.owner(), OWNER);
    }

    function test_owner_can_reset_board() public {
        vm.prank(OWNER);
        ttt.resetBoard();
    }

    function test_non_owner_cannot_reset_board() public {
        vm.expectRevert("Unauthorized");
        ttt.resetBoard();
    }

    function test_stores_player_X() public {
        assertEq(ttt.playerX(), PLAYER_X);
    }

    function test_stores_player_O() public {
        assertEq(ttt.playerO(), PLAYER_O);
    }

    function test_auth_nonplayer_cannot_mark_space() public {
        vm.expectRevert("Unauthorized");
        ttt.markSpace(0);
    }

    function test_auth_playerX_can_mark_space() public {
        vm.prank(PLAYER_X);
        ttt.markSpace(0);
    }

    function test_auth_playerO_can_mark_space() public {
        vm.prank(PLAYER_X);
        ttt.markSpace(0);

        vm.prank(PLAYER_O);
        ttt.markSpace(1);
    }
}
