// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Dices {
    uint public constant DICES_NUMBER = 265;
    uint public constant ARRAY_ENCODING_BYTES_SIZE = 32 + 32 + DICES_NUMBER * 32;

    address public winner;
    mapping(bytes32 => bool) used;

    constructor() {
        // Mark all of the winning dice combinations as used >:‑)
        uint[] memory winningCombo = new uint[](DICES_NUMBER);
        for (uint i; i < DICES_NUMBER; ++i) {
            if (i != 0)
                winningCombo[i-1] = 0;
            winningCombo[i] = 1;

            bytes32 key = keccak256(abi.encode(winningCombo));
            used[key] = true;
        }
    }

    /**
     * Checks if the winning combination has been used
     */
    modifier checkNotUsed() {
        // Checking calldata is of the right size
        require(msg.data.length == ARRAY_ENCODING_BYTES_SIZE+4, "Calldata out of bounds"); 

        // Hashing the numbers array directly in calldata for efficiency
        bytes32 hash = keccak256(msg.data[4:ARRAY_ENCODING_BYTES_SIZE + 4]);
        require(!used[hash], "Used");

        _;
    }

    /**
     * Claim a winning combination
     * @param dices the winning combination to attempt
     */
    function roll(uint[] calldata dices) public checkNotUsed {
        require(winner == address(0), "Already won");
        require(dices.length == DICES_NUMBER, "Too many dices");

        // The score of the player is the sum of the dices values
        uint score;
        for (uint i; i < DICES_NUMBER; ++i) {
            score += dices[i];
        }

        // If the score is exactly one, the player wins!
        require(score == 1, "Wrong sum");

        // Set winner, claim prize
        winner = msg.sender;
    }
}