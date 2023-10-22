// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {NoUseful, HW_Token, NFTReceiver} from "../src/ERC721Receiver.sol";

contract ReceiverTest is Test {
    
    NoUseful public noUseful;
    NFTReceiver public nftReceiver;
    HW_Token public hw_Token;
    uint256 deploymentTime;
    address user1;

    function setUp() public {
        user1 = makeAddr("Liam");
        noUseful = new NoUseful(user1);
        hw_Token = new HW_Token();
        nftReceiver = new NFTReceiver(address(hw_Token));
    }

    function testSenderGetNft() public {
        vm.startPrank(user1);
        bool isMintNoUserful = noUseful.mint(user1, 0);
        require(isMintNoUserful);

        noUseful.safeTransferFrom(user1, address(nftReceiver), 0);

        uint256 unNFT = noUseful.balanceOf(user1);
        uint256 noNFT = hw_Token.balanceOf(user1);

        assertEq(unNFT, 1);
        assertEq(noNFT, 1);
    }

}
