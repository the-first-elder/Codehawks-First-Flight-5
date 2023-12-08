// SPDX-License-Identifier: MIT

pragma solidity ~0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {SantasList} from "../../src/SantasList.sol";
import {SantaToken} from "../../src/SantaToken.sol";
import {TokenUri} from "../../src/TokenUri.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Handler} from "./Handler.t.sol";

contract Invariant is StdInvariant, Test {
    SantasList santasList;
    Handler handler;

    function setUp() external {
        santasList = new SantasList();
        handler = new Handler(santasList);
        targetContract(address(handler));
    }

    function invariant_testMaximumNumberOfmintedTokenHasAnAddressAndNotTheZeroAddress() external view {
        uint256 tokenNumerMinted = santasList.getTokenCounter();
        uint256 extraTokenNumberNotMinted = tokenNumerMinted;
        console.log("tokenNumerMinted", tokenNumerMinted);
        console.log("extraTokenNumberNotMinted", extraTokenNumberNotMinted);
        console.log(santasList.getOwnerOf(extraTokenNumberNotMinted));
        console.log("supply", SantaToken(santasList.getSantaToken()).totalSupply());

        if (tokenNumerMinted == 0) {
            return;
        }
        tokenNumerMinted -= 1;
        console.log(santasList.getOwnerOf(tokenNumerMinted));
        assert(santasList.getOwnerOf(tokenNumerMinted) != address(0));
        assert(santasList.getOwnerOf(extraTokenNumberNotMinted) == address(0));
    }

    function invariant_testMaxmumNftBalanceShouldBeOne() external {
        uint256 tokenNumerMinted = santasList.getTokenCounter();
        // uint256 extraTokenNumberNotMinted = tokenNumerMinted;
        if (tokenNumerMinted == 0) {
            return;
        }
        tokenNumerMinted -= 1;
        console.log("tokenMinted", tokenNumerMinted);
        for (uint256 i = 0; i < tokenNumerMinted; i++) {
            address nftOwner = santasList.getOwnerOf(i);
            console.log("nftOwner", nftOwner);
            uint256 ownerBalance = santasList.balanceOf(nftOwner);
            console.log("owner balance", ownerBalance);
            assertGe(ownerBalance, 1);
        }
    }
}
