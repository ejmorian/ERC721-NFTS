// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interface/ERC165.sol";
import "./interface/ERC721.sol";

library Address {
    function isContract(address _addr) public view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}

contract BasicNFT {
    using Address for address;

    string private constant _name = "Pixel";
    string private constant _symbol = "PXL";
    mapping(address => uint) private addressToBalance;
    mapping(uint256 => address) private tokenIdToBalance;
    mapping(bytes4 => bool) private checkInterface;

    bytes4 private constant ERC165_ID = 0x01ffc9a7;
    bytes4 private constant ERC721_ID = 0x80ac58cd;
    bytes4 private constant ERC721METADATA_ID = 0x5b5e139f;
    bytes4 private constant ERC721ENUMERABLE_ID = 0x780e9d63;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    constructor() {
        checkInterface[ERC165_ID] = true;
        checkInterface[ERC721_ID] = true;
        checkInterface[ERC721METADATA_ID] = true;
        checkInterface[ERC721ENUMERABLE_ID] = true;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return addressToBalance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return tokenIdToBalance[_tokenId];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable {
        transferFrom(_from, _to, _tokenId);

        if (_from.isContract()) {
            bytes4 signature = bytes4(
                keccak256(
                    "onERC721Received(address,address,uint256,bytes)returns(bytes4)"
                )
            );

            (bool success, bytes memory returnData) = _from.call(
                abi.encodeWithSelector(signature, _from, _to, _tokenId, data)
            );
            require(
                success && returnData.length == 0,
                "ERC721: transfer to non ERC721Receiver implementer"
            );
        }
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        transferFrom(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        if (
            msg.sender != ownerOf(_tokenId) ||
            msg.sender == getApproved(_tokenId)
        ) {
            if (ownerOf(_tokenId) == _from) {
                tokenIdToBalance[_tokenId] = _to;
                emit Transfer(_from, _to, _tokenId);
            } else {
                revert("ERC721: transfer of token that is not own");
            }
        } else {
            revert("Transfer: Permission Denied");
        }
    }

    function approve(address _approved, uint256 _tokenId) external payable {}

    function setApprovalForAll(address _operator, bool _approved) external {}

    function getApproved(uint256 _tokenId) public view returns (address) {}

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {}

    function supportsInterface(
        bytes4 interfaceID
    ) external view returns (bool) {
        return checkInterface[interfaceID];
    }

    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {}

    function totalSupply() external view returns (uint256) {}

    function tokenByIndex(uint256 _index) external view returns (uint256) {}

    function tokenOfOwnerByIndex(
        address _owner,
        uint256 _index
    ) external view returns (uint256) {}
}
