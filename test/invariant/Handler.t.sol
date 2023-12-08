// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {SantasList} from "../../src/SantasList.sol";
import {SantaToken} from "../../src/SantaToken.sol";
import {TokenUri} from "../../src/TokenUri.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Handler is Test {
    SantasList santasList;
    address santa;
    SantaToken santaToken;
    address buyingUser = makeAddr("buyingUser");

    constructor(SantasList _santasList) {
        santasList = _santasList;
        santa = santasList.getSanta();
        santaToken = SantaToken(santasList.getSantaToken());
    }

    modifier createMultipleAddress(uint32 amount) {
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, amount);
        address someUser = vm.addr(privateKey);
        vm.startPrank(someUser);
        _;
    }

    // function checkList(uint32 amount) public {
    //     string memory mnemonic = "test test test test test test test test test test test junk";
    //     uint256 privateKey = vm.deriveKey(mnemonic, amount);
    //     address someUser = vm.addr(privateKey);
    //     vm.startPrank(someUser);
    //     uint256 enumAmount = bound(amount, 0, 3);

    //     santasList.checkList(someUser, SantasList.Status(enumAmount));
    //     vm.stopPrank();
    // }

    // function checkTwice(uint32 amount) public {
    //     string memory mnemonic = "test test test test test test test test test test test junk";
    //     uint256 privateKey = vm.deriveKey(mnemonic, amount);
    //     address someUser = vm.addr(privateKey);
    //     vm.startPrank(santa);
    //     uint256 enumAmount = bound(amount, 0, 3);
    //     // console.log(status[0]);
    //     santasList.checkList(someUser, SantasList.Status(enumAmount));

    //     santasList.checkTwice(someUser, SantasList.Status(enumAmount));
    //     vm.stopPrank();
    // }

    // function collectPresent(uint32 amount) public {
    //     string memory mnemonic = "test test test test test test test test test test test junk";
    //     uint256 privateKey = vm.deriveKey(mnemonic, amount);
    //     address someUser = vm.addr(privateKey);
    //     uint256 enumAmount = bound(amount, 0, 3);
    //     if (enumAmount > 1) {
    //         return;
    //     }
    //     santasList.checkList(someUser, SantasList.Status(enumAmount));
    //     vm.startPrank(santa);
    //     santasList.checkTwice(someUser, SantasList.Status(enumAmount));
    //     vm.stopPrank();
    //     vm.warp(santasList.CHRISTMAS_2023_BLOCK_TIME() + 1);
    //     vm.startPrank(someUser);
    //     santasList.collectPresent();
    //     vm.stopPrank();
    // }

    function buyPresent(uint32 amount) public {
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, amount);
        address someUser = vm.addr(privateKey);
        vm.startPrank(address(santasList));
        santaToken.mint(address(santasList));
        santaToken.mint(address(santasList));
        santaToken.mint(someUser);
        // santaToken.approve(address(santasList), santaToken.balanceOf(address(santasList)));
        santaToken.transfer(buyingUser, 2 ether);// doesnt need aprroval
        vm.stopPrank();

        uint256 enumAmount = bound(amount, 0, 3);
        if (enumAmount != 1) {
            return;
        }
        // santasList.checkList(someUser, SantasList.Status(enumAmount));
        // vm.startPrank(santa);
        // santasList.checkTwice(someUser, SantasList.Status(enumAmount));
        // vm.stopPrank();
        // vm.warp(santasList.CHRISTMAS_2023_BLOCK_TIME() + 1);
        // vm.startPrank(someUser);
        // santasList.collectPresent();
        // vm.stopPrank();

        vm.startPrank(buyingUser);
        santasList.buyPresent(someUser);
        vm.stopPrank();
    }
}
