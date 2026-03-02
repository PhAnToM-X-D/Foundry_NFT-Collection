// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {IITR_NFT} from "src/IITR_NFT.sol";

contract InteractNFT is Script {
    IITR_NFT nft;
    string private URI;

    constructor(string memory _tokenURI) {
        nft = IITR_NFT(DevOpsTools.get_most_recent_deployment("IITR_NFT", block.chainid));
        URI = _tokenURI;
    }

    function run() external {
        vm.startBroadcast();
        nft.mintNFT(URI);
        vm.stopBroadcast();
    }
}
