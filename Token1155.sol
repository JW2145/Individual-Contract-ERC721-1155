// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Token1155 is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 constant testId = 0;

    // ERC721 public token;

    constructor() public ERC1155("") {
        // token =ERC721(test1,test2);
    }

    function mintERC1155(address minter) public {
        // _tokenIds.increment();
        // uint newItemId =  _tokenIds.current();
        _mint(minter, testId, 1, "");
        // _setTokenURI(newItemId, tokenURI);
        // return newItemId;
    }
}
