// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Akari is ERC721 {
    uint256 private s_tokenCounter;

    string private _tokenURI =
        "ipfs://QmaqwNyKmCRR3CdhMpu3yuzzLtVXRj5ctz698gjKb1MuTm";

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function mintAkari() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter += 1;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function tokenURI(
        uint256 /*tokenId*/
    ) public view override returns (string memory) {
        return _tokenURI;
    }
}
