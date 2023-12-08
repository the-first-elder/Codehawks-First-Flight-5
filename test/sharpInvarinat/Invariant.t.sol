// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

import {Dices} from "../../src/sharp.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Test} from "forge-std/Test.sol";
import {Handler} from "./Handler.t.sol";

contract Invariant is StdInvariant, Test {
    Dices dices;

    function setUp() public {
        dices = new Dices();
        Handler handler = new Handler(dices);
        targetContract(address(handler));
    }

    function invariant_testFunction() public view {
        assert(dices.winner() == address(0));
    }
}
