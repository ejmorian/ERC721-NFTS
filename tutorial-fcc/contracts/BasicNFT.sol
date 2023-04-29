//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    string private constant _name = "Patrol";
    string private constant _symbol = "PAT";
    uint256 private constant maxSupply = 100;
    uint256 private tokenCounter;

    constructor() ERC721(_name, _symbol) {}

    function mint(address _to, uint256 _tokenId) external {
        _tokenId = tokenCounter++;
        if (tokenCounter <= maxSupply) {
            _safeMint(_to, _tokenId);
            tokenCounter++;
        } else {
            revert("Limit has been reached");
        }
    }
}
