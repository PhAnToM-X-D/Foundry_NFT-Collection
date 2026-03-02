// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {DynamicNFT} from "../src/DynamicNFT.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/base64.sol";

contract Deploy_DynamicNFT is Script {
    DynamicNFT nft;

    function run() external returns (DynamicNFT) {
        string memory Huri = Base64.encode(bytes(string(abi.encodePacked(vm.readFile("img/happysvg.svg")))));
        string memory Suri = Base64.encode(bytes(string(abi.encodePacked(vm.readFile("img/sadsvg.svg")))));
        vm.startBroadcast();
        nft = new DynamicNFT(Huri, Suri);
        vm.stopBroadcast();
        return nft;
    }
}
