// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "oz/token/ERC721/ERC721.sol";
import "oz/token/ERC721/IERC721.sol";
import "oz/token/ERC721/IERC721Receiver.sol";
import "oz/access/Ownable.sol";
import "oz/token/ERC721/extensions/ERC721Burnable.sol";

contract BlindBox is ERC721, Ownable, ERC721Burnable {

    event SetTokenURI(uint256 indexed tokenId, string indexed tokenURI);

    uint16 _totalSupply;
    uint256 _deploymentTime;
    mapping(uint256 => address) _owners;
    mapping(uint256 => string) _tokenURIs;
    mapping(uint256 => bool) _isOpenBlind;
    string _blindBoxAddr;
    string _pikachuAddr;


    constructor(address initialOwner)
    ERC721("Blind Box NFT", "BBNFT")
    Ownable(initialOwner)
    {   
        _totalSupply = 500;
        _blindBoxAddr = "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/BlindBox.json";
        _pikachuAddr = "ipfs://QmZhioy9qwriJBLAocRVK6A5c7uZnT2fzBJN8kujyuE2D3/Pikachu.json";
        _deploymentTime = block.timestamp;
    }

    function mint(address to, uint256 tokenId) public returns(bool){
        require(_totalSupply > 0, "ERROR: No more NFT can mint");
        _mint(to, tokenId);
        _tokenURIs[tokenId] = _blindBoxAddr;
        _totalSupply -= 1;
        return true;
    }

    function openBlindBox() external onlyOwner returns(bool){
        require(block.timestamp >= _deploymentTime + 10 minutes, "It's not time to open the blind box yet");
        for(uint256 i; i < 500 - _totalSupply; i++){
            _tokenURIs[i] = _pikachuAddr;
            _isOpenBlind[i] = true;
            emit SetTokenURI(i, _pikachuAddr);
        }
        return true;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ownerOf(tokenId);
        require(owner != address(0), "ERROR: token id is not valid");
        return _tokenURIs[tokenId];
    }

    function totalSupply() external view returns(uint16){
        return _totalSupply;
    }

}