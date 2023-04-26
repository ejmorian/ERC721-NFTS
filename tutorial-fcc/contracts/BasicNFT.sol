//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interface/ERC721.sol";
import "./interface/ERC165.sol";
import "./library/Address.sol";

contract BasicNFT {
    modifier onlyDeployer() {
        require(msg.sender == i_deployer, "Permission Denied.");
        _;
    }

    using Address for address;

    string private i_name;
    string private i_symbol;
    address private immutable i_deployer;
    uint256 private i_totalSupply;
    uint256 private constant c_maxSupply = 10;

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

    constructor(string memory _name, string memory _symbol) {
        checkInterface[0x80ac58cd] = true; //ERC 721
        checkInterface[0x01ffc9a7] = true; //ERC 165
        checkInterface[0x5b5e139f] = true; // ERC721 Metadata
        i_name = _name;
        i_symbol = _symbol;
        i_deployer = msg.sender;
    }

    function mint(address _to) public onlyDeployer {
        uint256 _tokenId = totalSupply() + 1;

        if (totalSupply() <= maxSupply()) {
            tokenIdToAddress[_tokenId] = _to;
            addressToBalance[_to]++;
            addTotalSupply(1);
            emit Transfer(address(this), _to, _tokenId);
        } else {
            revert("Max Supply Reached.");
        }
    }

    function addTotalSupply(uint256 amount) private {
        i_totalSupply += amount;
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
        addressToBalance[_from] -= 1;
        addressToBalance[_to] += 1;

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

    function name() external view returns (string memory _name) {
        return i_name;
    }

    function symbol() external view returns (string memory _symbol) {
        return i_symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {}

    function maxSupply() public pure returns (uint256) {
        return c_maxSupply;
    }

    function totalSupply() public view returns (uint256) {
        return i_totalSupply;
    }
}
