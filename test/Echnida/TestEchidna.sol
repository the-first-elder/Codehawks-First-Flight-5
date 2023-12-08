// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {SantasList} from "../../src/SantasList.sol";
import {SantaToken} from "../../src/SantaToken.sol";
import {TokenUri} from "../../src/TokenUri.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import {Handler} from "./Handler.t.sol";

contract TestEchidna is SantasList {
    address owner;
    SantaToken santaToken;
    uint256 bal;
    address me;
    // uint s_tokenCounter;

    // constructor() {
    //     owner = msg.sender;
    //     santaToken = SantaToken(i_santaToken);
    //     // vm.startPrank(i_santa);
    //     santaToken.mint(address(this));
    //     santaToken.mint(address(this));
    //     santaToken.mint(address(this));
    //     santaToken.approve(address(this), santaToken.balanceOf(address(this)));
    //     santaToken.transfer(owner, 2 ether);
    //     // vm.stopPrank();
    // }

    constructor() {
        bal = 1;
        me = getOwnerOf(0);
        checkList(msg.sender, Status.EXTRA_NICE);
        getNaughtyOrNiceOnce(msg.sender);
        // bal=1;
    }

    function echidna_testMaximumNumberOfmintedTokenHasAnAddressAndNotTheZeroAddress() public returns (bool) {
        // return (getNaughtyOrNiceOnce(msg.sender) == Status.NICE);
        return getOwnerOf(0) == address(0);
    }

    function echidna_testNoOneShouldBeableToMint() public returns (bool) {
        return getTokenCounter() == 0;
    }

    // function echidna_testMaxmumNftBalanceShouldBeOne() external {
    //     uint256 tokenNumerMinted = santasList.getTokenCounter();
    //     // uint256 extraTokenNumberNotMinted = tokenNumerMinted;
    //     if (tokenNumerMinted == 0) {
    //         return;
    //     }
    //     tokenNumerMinted -= 1;
    //     // console.log("tokenMinted",tokenNumerMinted);
    //     for (uint256 i = 0; i < tokenNumerMinted; i++) {
    //         address nftOwner = santasList.getOwnerOf(i);
    //         console.log("nftOwner",nftOwner);
    //         uint256 ownerBalance = santasList.balanceOf(nftOwner);
    //         console.log("owner balance", ownerBalance);
    //        return assertGe(ownerBalance, 1);
    //     }
    // }
}
