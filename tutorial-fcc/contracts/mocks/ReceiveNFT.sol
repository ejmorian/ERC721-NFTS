//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../interface/ERC721TokenReceiver.sol";

contract receiveNFT {
    event ReceiveNFT(
        address indexed _operator,
        address indexed _from,
        uint256 indexed _tokenId,
        bytes _data
    );

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes memory _data
    ) external returns (bytes4) {
        emit ReceiveNFT(_operator, _from, _tokenId, _data);

        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
