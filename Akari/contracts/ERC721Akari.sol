// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Akari is ERC721 {
    uint256 private s_tokenCounter;

    string private _tokenURI =
        "https://gateway.pinata.cloud/ipfs/QmU6Q9Q5bPD4KK7Th2XoCATPV9vr3F2uBEhDRVSSq3FGD8?_gl=1*z5syvj*rs_ga*ZGYwYWM2ZjYtYzgyNC00ZDBiLTk4ZjQtNjNhNTFiNzMxYWVl*rs_ga_5RMPXG14TE*MTY4MjUxODk3NS4xLjEuMTY4MjUxOTkxNi42MC4wLjA.";

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
