// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

contract ICO {
    bool is_paused;
    address owner = msg.sender;

    function IC0() public {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }
		
    function resume() public isOwner {
      is_paused = false;      
    }
}