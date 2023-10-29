// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {BlindBox} from "../src/ERC721BlindBox.sol";

contract BlindBoxTest is Test {
    
    BlindBox public blindBox;
    uint256 deploymentTime;
    address user1;
    address user2;

    function setUp() public {
        user1 = makeAddr("Liam");
        user2 = makeAddr("Bob");
        deploymentTime = block.timestamp;
        blindBox = new BlindBox(user1);
    }

    function testAfterOpenBlindBox() public {

        vm.startPrank(user1);
        bool isMint1 = blindBox.mint(user1);
        require(isMint1);
        bool isMint2 = blindBox.mint(user2);
        require(isMint2);
        string memory beforeTokenUri1 = blindBox.tokenURI(0);
        string memory beforeTokenUri2 = blindBox.tokenURI(1);

        assertEq(beforeTokenUri1, "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/BlindBox.json");
        assertEq(beforeTokenUri2, "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/BlindBox.json");

        vm.warp(deploymentTime + 10 minutes);
        bool isOpenBlind = blindBox.openBlindBox();
        require(isOpenBlind);

        string memory afterTokenUri1 = blindBox.tokenURI(0);
        string memory afterTokenUri2 = blindBox.tokenURI(1);    

        assertEq(afterTokenUri1, "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/Pikachu.json");
        assertEq(afterTokenUri2, "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/Pikachu.json");

        vm.stopPrank();
    }
    



}
