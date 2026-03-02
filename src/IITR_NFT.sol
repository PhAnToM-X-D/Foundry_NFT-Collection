// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract IITR_NFT is ERC721 {
    uint256 public s_tokenCounter;
    mapping(uint256 => string) private s_tokenURIs;

    constructor() ERC721("IITR_NFT", "IITR") {
        s_tokenCounter = 0;
    }

    function mintNFT(string memory _tokenURI) public {
        s_tokenURIs[s_tokenCounter] = _tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 _tokenID) public view override returns (string memory) {
        return s_tokenURIs[_tokenID];
    }
}
