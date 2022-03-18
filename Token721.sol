// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Token721 is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // ERC721 public token;

    constructor(string memory test1, string memory test2)
        public
        ERC721(test1, test2)
    {
        // token =ERC721(test1,test2);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function mintItem(address minter) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(minter, newItemId);
        // _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function testingToken(address minter, uint256 index) public {
        _mint(minter, index);
    }
}
