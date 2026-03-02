// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFT is ERC721 {
    error msgSenderNotOwner();

    enum Mood {
        HAPPY,
        SAD
    }

    uint256 public tokenCounter;

    mapping(uint256 => string) tokenURI;
    mapping(uint256 => Mood) mood;
    mapping(uint256 => address) tokenIdToOwner;

    string HAPPYIMGURI;
    string SADIMGURI;

    constructor(string memory _HAPPYIMGURI, string memory _SADIMGURI) ERC721("DynamicNFT", "DNFT") {
        HAPPYIMGURI = _HAPPYIMGURI;
        SADIMGURI = _SADIMGURI;
        tokenCounter = 0;
    }

    function mintNFT() public {
        _safeMint(msg.sender, tokenCounter);
        tokenURI[tokenCounter] = HAPPYIMGURI;
        mood[tokenCounter] = Mood.HAPPY;
        tokenCounter++;
    }

    modifier onlyOwner(uint256 tokenId) {
        if (msg.sender != tokenIdToOwner[tokenId]) {
            revert msgSenderNotOwner();
        }
        _;
    }

    function _tokenURI(uint256 _tokenId) public view returns (string memory) {
        string memory imageURI;
        if (mood[_tokenId] == Mood.HAPPY) {
            imageURI = HAPPYIMGURI;
        } else {
            imageURI = SADIMGURI;
        }
        return (string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    string(
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name:"',
                                    name(),
                                    '", description: "A basic NFT reflecting the mood of the owner" , imageURI: "',
                                    imageURI,
                                    '", attributes: [{trait_type: "moodiness", value:"100"}]'
                                )
                            )
                        )
                    )
                )
            ));
    }

    function changeMood(uint256 tokenId) public onlyOwner(tokenId) {
        if (mood[tokenId] == Mood.HAPPY) {
            mood[tokenId] = Mood.SAD;
            tokenURI[tokenId] = SADIMGURI;
        } else {
            mood[tokenId] = Mood.HAPPY;
            tokenURI[tokenId] = HAPPYIMGURI;
        }
    }
}
