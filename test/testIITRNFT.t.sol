// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IITR_NFT} from "src/IITR_NFT.sol";
import {DeployNFT} from "script/deploy_IITR_NFT.s.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract testIITRNFT is Test {
    IITR_NFT iitrNFT;
    DeployNFT deployer;
    address public user = makeAddr("user");

    function setUp() external {
        deployer = new DeployNFT();
        iitrNFT = deployer.run();
    }

    function testConstructor() external view {
        assertEq(iitrNFT.name(), "IITR_NFT");
        assertEq(iitrNFT.symbol(), "IITR");
        assertEq(iitrNFT.s_tokenCounter(), 0);
    }

    function testMintNFT() external {
        vm.prank(user);
        string memory tokenURI = "https://example.com/token/1";
        iitrNFT.mintNFT(tokenURI);
        assertEq(iitrNFT.s_tokenCounter(), 1);
        assertEq(iitrNFT.tokenURI(0), tokenURI);
        assertEq(iitrNFT.ownerOf(0), user);
    }

    function testTokenURINotExist() external view {
        assertEq(iitrNFT.tokenURI(3), "");
    }
}
