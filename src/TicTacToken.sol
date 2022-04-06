// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

contract TicTacToken {
    string[9] public board;

    function getBoard() public view returns (string[9] memory) {
        return board;
    }

    function markSpace(uint256 space, string calldata symbol) public {
        board[space] = symbol;
    }
}
