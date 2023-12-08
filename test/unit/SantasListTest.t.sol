// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {SantasList} from "../../src/SantasList.sol";
import {SantaToken} from "../../src/SantaToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {_CheatCodes} from "../mocks/CheatCodes.t.sol";

contract SantasListTest is Test {
    SantasList santasList;
    SantaToken santaToken;

    address user = makeAddr("user");
    address santa = makeAddr("santa");
    _CheatCodes cheatCodes = _CheatCodes(HEVM_ADDRESS);

    function setUp() public {
        vm.startPrank(santa);
        santasList = new SantasList();
        santaToken = SantaToken(santasList.getSantaToken());
        vm.stopPrank();
    }

    modifier randomUser(uint32 amount) {
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, amount);
        address someUser = vm.addr(privateKey);
        vm.startPrank(someUser);
        _;
    }

    function testCheckList(uint256 amount) public {
        vm.prank(santa);
        if (amount % 2 == 0) {
            santasList.checkList(user, SantasList.Status.NICE);
            assertEq(uint256(santasList.getNaughtyOrNiceOnce(user)), uint256(SantasList.Status.NICE));
        }
    }

    function testCheckListTwice() public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.NICE);
        santasList.checkTwice(user, SantasList.Status.NICE);
        vm.stopPrank();

        assertEq(uint256(santasList.getNaughtyOrNiceOnce(user)), uint256(SantasList.Status.NICE));
        assertEq(uint256(santasList.getNaughtyOrNiceTwice(user)), uint256(SantasList.Status.NICE));
    }

    //  didnt fuzz...
    function testCantCheckListTwiceWithDifferentThanOnce() public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.NICE);
        vm.expectRevert();
        santasList.checkTwice(user, SantasList.Status.NAUGHTY);
        vm.stopPrank();
    }

    // fuzzed good to go
    function testCantCollectPresentBeforeChristmas(uint32 amount) public {
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, amount);
        address someUser = vm.addr(privateKey);
        vm.startPrank(someUser);
        vm.expectRevert(SantasList.SantasList__NotChristmasYet.selector);
        santasList.collectPresent();
    }

    // fuzzed good to go....
    function testCantCollectPresentIfAlreadyCollected(uint256 amount) public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.NICE);
        santasList.checkTwice(user, SantasList.Status.NICE);
        vm.stopPrank();

        vm.assume(amount > santasList.PURCHASED_PRESENT_COST());

        vm.warp(amount);

        vm.startPrank(user);
        santasList.collectPresent();
        vm.expectRevert(SantasList.SantasList__AlreadyCollected.selector);
        santasList.collectPresent();
    }

    // fuzzed good to go
    function testCollectPresentNice(uint256 amount) public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.NICE);
        santasList.checkTwice(user, SantasList.Status.NICE);
        vm.stopPrank();

        vm.assume(amount > santasList.PURCHASED_PRESENT_COST());
        vm.warp(amount);
        // vm.warp(amount); gives santa not yet christmas error since time is less than block.time stamp

        vm.startPrank(user);
        santasList.collectPresent();
        assert(santasList.getOwnerOf(0) != address(0));

        assertEq(santasList.balanceOf(user), 1);
        vm.stopPrank();
    }

    // fuzzed good to go...
    function testCollectPresentExtraNice(uint256 amount) public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.EXTRA_NICE);
        santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
        vm.stopPrank();
        vm.assume(amount > santasList.PURCHASED_PRESENT_COST());

        // vm.warp(amount); gives santa not yet christmas error since time is less than block.time stamp

        vm.startPrank(user);
        santasList.collectPresent();
        assertEq(santasList.balanceOf(user), 1);
        assertEq(santaToken.balanceOf(user), 1e18);
        vm.stopPrank();
    }

    // fuzzed good to go..
    function testCantCollectPresentUnlessAtLeastNice(uint256 amount) public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.NAUGHTY);
        santasList.checkTwice(user, SantasList.Status.NAUGHTY);
        vm.stopPrank();

        vm.warp(amount); // amount here is useless since state is ever changing..

        vm.startPrank(user);
        // vm.expectRevert(SantasList.SantasList__AlreadyCollected.selector);
        vm.expectRevert();
        santasList.collectPresent();
    }

    //  fuzzed good to go
    function testBuyPresent(uint256 amount) public {
        vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.EXTRA_NICE);
        santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
        vm.stopPrank();
        vm.assume(amount > santasList.PURCHASED_PRESENT_COST());
        // using only amount gave us arithmetic overflow and underflow...
        vm.warp(amount);

        vm.startPrank(user);
        santaToken.approve(address(santasList), 1e18);
        // vm.expectRevert();
        santasList.collectPresent();
        santasList.buyPresent(user);
        assertEq(santasList.balanceOf(user), 2);
        assertEq(santaToken.balanceOf(user), 0);
        vm.stopPrank();
    }

    //  fuzzed.. good to go
    function testOnlyListCanMintTokens(uint32 amount) public randomUser(amount) {
        vm.expectRevert();
        santaToken.mint(user);
    }

    // fuzzed good to go

    function testOnlyListCanBurnTokens(uint32 amount) public randomUser(amount) {
        vm.expectRevert();
        santaToken.burn(user);
    }

    // fuzzed.... good to go
    function testTokenURI(uint256 amount) public {
        vm.assume(amount > 1);
        string memory tokenURI = santasList.tokenURI(amount);
        console.log(amount);
        assertEq(tokenURI, santasList.TOKEN_URI());
    }

    function testGetSantaToken() public {
        assertEq(santasList.getSantaToken(), address(santaToken));
    }

    function testGetSanta() public {
        assertEq(santasList.getSanta(), santa);
    }

    // function testPwned() public {
    //     string[] memory cmds = new string[](2);
    //     cmds[0] = "touch";
    //     cmds[1] = string.concat("youve-been-pwned");
    //     cheatCodes.ffi(cmds);
    // }

    function testOwnerById(uint amount) public {
         vm.startPrank(santa);
        santasList.checkList(user, SantasList.Status.EXTRA_NICE);
        santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
        vm.stopPrank();
        vm.assume(amount > santasList.PURCHASED_PRESENT_COST());
        // using only amount gave us arithmetic overflow and underflow...
        vm.warp(amount);

        vm.startPrank(user);
        santaToken.approve(address(santasList), 1e18);
        // vm.expectRevert();
        santasList.collectPresent();
        // santasList.buyPresent(user);
        assertEq(santasList.balanceOf(user), 1);
        assertEq(santaToken.balanceOf(user), 1e18);
        vm.stopPrank();
        console.log(santasList.getOwnerOf(amount));
        assert(santasList.getOwnerOf(1) != address(0));
    }
}
