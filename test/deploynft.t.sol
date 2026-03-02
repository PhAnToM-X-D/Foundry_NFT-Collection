// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DynamicNFT} from "src/DynamicNFT.sol";
import {Deploy_DynamicNFT} from "script/deploy_DynamicNFT.s.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract testDynamicNFT is Test {
    DynamicNFT dynamicNFT;
    Deploy_DynamicNFT deployer;
    address public user = makeAddr("user");

    function setUp() external {
        deployer = new Deploy_DynamicNFT();
        dynamicNFT = deployer.run();
    }

    function testConstructor() external view {
        assertEq(dynamicNFT.name(), "DynamicNFT");
        assertEq(dynamicNFT.symbol(), "DNFT");
        assertEq(dynamicNFT.tokenCounter(), 0);
    }

    function testFlipTokenToSad() public {
        vm.prank(user);
        dynamicNFT.mintNFT();

        vm.prank(user);
        dynamicNFT.changeMoodOfNFT(0);

        assertEq(keccak256(abi.encodePacked(dynamicNFT.getMood(0))), keccak256(abi.encodePacked("SAD")));
        assertEq(dynamicNFT.getTokenURIfromTokenID(0), dynamicNFT.SADIMGURI1());
    }
}
