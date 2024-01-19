// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NOTE: this ONFT contract has no public minting logic.
// must implement your own minting logic in child classes
import "lib/solidity-examples/contracts/token/onft721/ONFT721.sol";

contract TestNFT is ONFT721 {

    constructor(    
        string memory _name,
        string memory _symbol,
        uint _minGasToTransfer,
        address _lzEndpoint) ONFT721(_name, _symbol, _minGasToTransfer, _lzEndpoint) {}


    function mint(uint256 tokenId) external {
        _mint(msg.sender, tokenId);
    }

    function burn(uint256 tokenId) external {
        require(msg.sender == ERC721.ownerOf(tokenId), "Cannot burn others");
        _burn(tokenId);
    }
}


/**

_minGasToTransfer: The minimum gas needed to transfer and store your NFT, typically 100k for ERC721. 
 This value would vary depending on your contract complexity, it's recommended to test.
 If this value is set too low, the destination tx will fail and a manual retry is needed.

 */