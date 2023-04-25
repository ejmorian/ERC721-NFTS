//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interface/ERC721.sol";
import "./interface/ERC165.sol";
import "./library/Address.sol";

contract BasicNFT {
    using Address for address;

    mapping(bytes4 => bool) private checkInterface;
    mapping(address => uint256) private addressToBalance;
    mapping(address => uint256[]) private addressToAssets;
    mapping(uint256 => address) private tokenIdToAddress;
    mapping(uint256 => address[]) private permission;
    mapping(address => mapping(address => bool)) private permissionAll;

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
        checkInterface[0x80ac58cd] = true; //ERC 721
        checkInterface[0x01ffc9a7] = true; //ERC 165
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable {
        transferFrom(_from, _to, _tokenId);

        bytes4 functionSelector = bytes4(
            keccak256("onERC721Received(address,address,uint256,bytes)")
        );
        if (_to.isContract()) {
            (bool success, bytes memory returnData) = _to.call(
                abi.encodeWithSelector(
                    functionSelector,
                    _from,
                    _to,
                    _tokenId,
                    data
                )
            );

            require(success, "call function is not succesful");

            require(
                bytes4(returnData) == functionSelector,
                "Expected Return Value Invalid"
            );
        }
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        transferFrom(_from, _to, _tokenId);

        bytes memory data = abi.encode("");

        bytes4 functionSelector = bytes4(
            keccak256("onERC721Received(address,address,uint256,bytes)")
        );
        if (_to.isContract()) {
            (bool success, bytes memory returnData) = _to.call(
                abi.encodeWithSelector(
                    functionSelector,
                    _from,
                    _to,
                    _tokenId,
                    data
                )
            );

            require(success, "call function is not succesful");

            require(
                bytes4(returnData) == functionSelector,
                "Expected Return Value Invalid"
            );
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        //Throws unless `msg.sender` is the current owner, an authorized, operator, or the approved address for this NFT. Throws if `_from` is not the current owner.
        require(
            msg.sender == ownerOf(_tokenId) ||
                isApprovedForAll(_from, msg.sender) ||
                msg.sender == getApproved(_tokenId),
            "Permission Denied"
        );
        // Throws if `_to` is the zero address.
        require(_to != address(0), "Invalid Recipient Address");
        // Throws if _tokenId` is not a valid NFT.
        require(ownerOf(_tokenId) != address(0), "Invalid Token Id");

        tokenIdToAddress[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(
            addressToBalance[_owner] != 0,
            "Invalid Address: Balance Is Zero."
        );
        return addressToBalance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(
            tokenIdToAddress[_tokenId] != address(0),
            "Invalid Token ID: No Owner Found."
        );
        return (tokenIdToAddress[_tokenId]);
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) public view returns (bool) {
        return permissionAll[_operator][_owner];
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        if (permission[_tokenId].length > 1) {
            revert("Multiple Operators Found.");
        } else {
            return permission[_tokenId][0];
        }
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        if (_approved) {
            for (uint i = 0; i < addressToAssets[msg.sender].length; i++) {
                approve(_operator, addressToAssets[msg.sender][i]);
            }
            permissionAll[_operator][msg.sender] = _approved;
            emit ApprovalForAll(msg.sender, _operator, _approved);
        } else {
            permissionAll[_operator][msg.sender] = _approved;
            emit ApprovalForAll(msg.sender, _operator, _approved);
        }
    }

    function approve(address _approved, uint256 _tokenId) public payable {
        if (msg.sender == ownerOf(_tokenId)) {
            permission[_tokenId].push(_approved);
            emit Approval(msg.sender, _approved, _tokenId);
        } else {
            revert("Permission Denied.");
        }
    }

    function supportsInterface(
        bytes4 interfaceID
    ) external view returns (bool) {
        return checkInterface[interfaceID];
    }
}
