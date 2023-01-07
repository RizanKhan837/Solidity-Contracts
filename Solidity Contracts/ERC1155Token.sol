// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";


contract MyTokens is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply{
    constructor() ERC1155("https://ipfs.io/ipfs") {}

    mapping(uint256 => string) public _nfturi;
    uint256 _tokenIds;

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 amount, string memory _selfuri, bytes memory data)
        public
        onlyOwner
    {
        _tokenIds++;
        _nfturi[_tokenIds] = _selfuri;
        require(!exists(_tokenIds), "Already Minted");
        _mint(account, _tokenIds, amount, data);
    }

    function mintBatch(address to, uint256 quantity, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        for(uint256 i = 0; i < quantity; i++){
            _tokenIds++;
            _mint(to, _tokenIds, amounts[i], data);
        }
    }

    function uri(uint256 id) public view virtual override returns (string memory) {
        return _nfturi[id];
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
