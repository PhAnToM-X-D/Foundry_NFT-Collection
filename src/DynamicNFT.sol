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

    mapping(uint256 => string) private s_tokenURI;
    mapping(uint256 => Mood) private mood;
    mapping(uint256 => address) private tokenIdToOwner;
    mapping(address => uint256[]) private ownerToTokenIDs;

    string HAPPYIMGURI;
    string SADIMGURI;

    constructor(string memory _HAPPYIMGBASE64ENCODE, string memory _SADIMGBASE64ENCODE) ERC721("DynamicNFT", "DNFT") {
        HAPPYIMGURI = _getImageURIFromBaseEncode(_HAPPYIMGBASE64ENCODE);
        SADIMGURI = _getImageURIFromBaseEncode(_SADIMGBASE64ENCODE);
        tokenCounter = 0;
    }

    function mintNFT() public {
        _safeMint(msg.sender, tokenCounter);
        s_tokenURI[tokenCounter] = HAPPYIMGURI;
        mood[tokenCounter] = Mood.HAPPY;
        tokenIdToOwner[tokenCounter] = msg.sender;
        ownerToTokenIDs[msg.sender].push(tokenCounter);
        tokenCounter++;
    }

    modifier onlyOwner(uint256 tokenId) {
        if (msg.sender != tokenIdToOwner[tokenId]) {
            revert msgSenderNotOwner();
        }
        _;
    }

    function _tokenURIGenerationForTokenID(uint256 _tokenId) public view returns (string memory) {
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

    function _tokenURIGenerationForURI(string memory _imguri) public view returns (string memory) {
        string memory imageURI = _imguri;
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

    function changeMoodOfNFT(uint256 tokenId) public onlyOwner(tokenId) {
        if (mood[tokenId] == Mood.HAPPY) {
            mood[tokenId] = Mood.SAD;
            s_tokenURI[tokenId] = SADIMGURI;
        } else {
            mood[tokenId] = Mood.HAPPY;
            s_tokenURI[tokenId] = HAPPYIMGURI;
        }
    }

    function _getImageURIFromBaseEncode(string memory _base64ImageURI) private pure returns (string memory) {
        string memory FinalURI = string(abi.encodePacked("data:image/svg+xml;base64,", _base64ImageURI));
        return FinalURI;
    }

    function getOwnerByTokenId(uint256 _tokenID) public view returns (address) {
        return tokenIdToOwner[_tokenID];
    }

    function getTokenIDsOwnedByAddress(address _owner) public view returns (uint256[] memory) {
        return ownerToTokenIDs[_owner];
    }

    function getTokenURIfromTokenID(uint256 _tokenID) public view returns (string memory) {
        return s_tokenURI[_tokenID];
    }

    function getTotalNFTsInCirculationCount() public view returns (uint256) {
        return tokenCounter;
    }

    function getMood(uint256 _tokenID) public view returns (string memory) {
        if (mood[_tokenID] == Mood.HAPPY) {
            return "HAPPY";
        } else {
            return "SAD";
        }
    }

    function SADIMGURI1() public view returns (string memory) {
        return _tokenURIGenerationForURI(SADIMGURI);
    }
}
