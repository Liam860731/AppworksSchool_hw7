// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NoUseful is ERC721, Ownable, ERC721Burnable {

    constructor(address initialOwner)
    ERC721("No useful NFT", "UNNFT")
    Ownable(initialOwner)
    {}

    function mint(address to, uint256 tokenId) public onlyOwner returns(bool){
        _mint(to, tokenId);
        return true;
    }

}

contract HW_Token is ERC721, ERC721Burnable {

    constructor()
        ERC721("Don't send NFT to me", "NONFT")
    {}

    function mint(address to, uint256 tokenId) public returns(bool){
        _mint(to, tokenId);
        return true;
    }

    function _baseURI() internal view override virtual returns(string memory){
        return "https://imgur.com/IBDi02f";
    }

}

contract NFTReceiver is IERC721Receiver, HW_Token {

    address public _owner = msg.sender;
    HW_Token public hwToken;

    constructor(address hwTokenAddr)
    { 
      hwToken = HW_Token(hwTokenAddr);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external virtual override returns (bytes4){
        operator = address(this);

        if(msg.sender != address(hwToken) ){
            IERC721(msg.sender).safeTransferFrom(operator, from, tokenId, data);
            hwToken.mint(from, tokenId);
        }

        return this.onERC721Received.selector;
    }
}
