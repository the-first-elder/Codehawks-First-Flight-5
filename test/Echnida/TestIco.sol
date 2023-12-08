// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

import "./Ico.sol";

// ICOFuzzTest.sol
contract ICOFuzzTest is ICO {

    constructor() public {
        is_paused = true;
        owner = address(0x0);
    }

    function echidna_test_pause() public view returns (bool) {
        return is_paused == true;
    }
}
