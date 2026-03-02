// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "lib/forge-std/src/Script.sol";
import {IITR_NFT} from "src/IITR_NFT.sol";

contract DeployNFT is Script {
    function run() external returns (IITR_NFT) {
        vm.startBroadcast();
        IITR_NFT nft = new IITR_NFT();
        vm.stopBroadcast();
        return nft;
    }
}
