//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract BasicNFT is ERC721 {
    string private constant _name = "Patrol";
    string private constant _symbol = "PAT";
    uint256 private constant maxSupply = 100;
    uint256 private tokenCounter = 1;

    constructor() ERC721(_name, _symbol) {}

    function mint() external {
        address _to = msg.sender;
        if (tokenCounter <= maxSupply) {
            _safeMint(_to, tokenCounter);
            tokenCounter++;
        } else {
            revert("Limit has been reached");
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmNUe6uqHgFGSDjFmYmnmu3M8iFmh4PeZgsikz6xj8Maf7/";
    }

    function getTokenCounter() external view returns (uint256) {
        return tokenCounter;
    }
}
