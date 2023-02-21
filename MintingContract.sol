// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is ERC721URIStorage, Ownable {
    uint256[] private mintedIds;
    uint256[] private availableIds;

    constructor() ERC721("MyCoolNFTs", "MCN") {
        availableIds = new uint256[](100);

        for (uint256 i = 0; i < availableIds.length; i++) {
            availableIds[i] = i + 1;
        }
    }

    function safeRandomMint(
        address _to, 
        string calldata _uri
        ) external onlyOwner {
        uint256 tokenId = getRandomNumber(availableIds);
        removeAtIndex(tokenId - 1);
        mintedIds.push(tokenId);
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _uri);
    }

    function getAvailableIds() public view returns (uint256[] memory) {
        return availableIds;
    }

    function getMintedIds() public view returns (uint256[] memory) {
        return mintedIds;
    }

    function isIdAvailable(uint256 _number)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < availableIds.length; i++) {
            if (availableIds[i] == _number) {
                return true;
            }
        }
        return false;
    }

    function getRandomNumber(uint256[] memory numbers)
        private
        view
        returns (uint256)
    {
        require(numbers.length > 0, "Array must not be empty");

        uint256 randomIndex = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, msg.sender, block.prevrandao)
            )
        ) % numbers.length;
        uint256 randomNumber = numbers[randomIndex];

        return randomNumber;
    }

    function removeAtIndex(uint256 index) private {
        require(index < availableIds.length, "Index out of bounds");

        for (uint256 i = index; i < availableIds.length - 1; i++) {
            availableIds[i] = availableIds[i + 1];
        }

        availableIds.pop();
    }
}
