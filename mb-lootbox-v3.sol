// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract MBLOOTBOX is ERC1155, AccessControl, Pausable, ERC1155Burnable, ERC1155Supply {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    address addA;
    address addB;
    address addC;
    address addD;
    uint256 addAN = 44;
    uint256 addBN = 54;
    uint256 addCN = 95;
    uint256 addDN = 90;

    constructor() 
        ERC1155("MetaBound LootBox Private Sale") {
            _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
            _grantRole(URI_SETTER_ROLE, msg.sender);
            _grantRole(PAUSER_ROLE, msg.sender);
            _grantRole(MINTER_ROLE, msg.sender);
            addA = msg.sender;
            addB = msg.sender;
            addC = msg.sender;
            addD = msg.sender;
    }

    string[] public boxName = ["BASIC", "BASIC PLUS", "BRONZE", "SILVER", "GOLD", "PLATINUM", "EMERALD", "DIAMOND"];
    uint256[] public mintRate = [0.5 ether, 1 ether, 2.5 ether, 5 ether, 10 ether, 20 ether, 40 ether, 80 ether];
    uint256[] public mintTotal = [0, 0, 0, 0, 0, 0, 0, 0];
    uint256[] public boxTotalSupply = [300, 150, 50, 25, 10, 5, 3, 1];

  /*
.  * Loops through the mintedByInvestor and returns true if previouslly minted that 
   * NFT
   */

  // we need something like this: array[wallet] = [0,4,2,5];
  mapping (address => uint256) nftsMintedByInvestor;

  // we need on FE
  // function getMintedByAddress(address _address) public view returns(uint256[] memory) {

  //   uint256[] memory alreadyMinted = [0,0,0,0,0,0,0,0];
    
  //   for(uint256 n = 0;n<boxName.length;n++) {
  //     if(balanceOf(_address, n) > 0) {
  //       alreadyMinted[n] = 1;
  //     }
  //   }
  //   return alreadyMinted;
  // }
  
  function hasMintedNft(address _address, uint256 nftId) public view returns(bool) {
    return balanceOf(_address, nftId) > 0;
  }

  /**
   * Add a collection of NFTs that have been minted to the investor
   */
  function addMintedToInvestor(address _address, uint256 _nftIds) private {
    
    nftsMintedByInvestor[_address] = _nftIds;

  }
        
    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mintSingleBox(uint256 id, uint256 amount)
        payable
        public
    {
        require(id <= boxTotalSupply.length, "Loot Box if fully minted out");
        require(id > 0 , "Loot Box doesn't exist");
        uint256 index = id - 1;
        require(mintTotal[index] + amount <= boxTotalSupply[index], "Not enough boxes to mint");
        require(msg.value >= amount * mintRate[index], "Not enough ether sent");
        _mint(msg.sender, id, amount, "");
        mintTotal[index] += amount;
    }

    function mintMultipleBoxes(uint256[] memory ids)
        payable
        public
    {

      uint256 _mintRateTotal;
      uint256 _validNftCounter = 0;

      uint256[] memory validNfts = new uint[](boxName.length);

      for (uint256 i = 0; i < ids.length; i++) {

          uint256 pickedNftIndex = ids[i];

        require(boxName.length < pickedNftIndex, "Loot Box doesn't exist");

        if(hasMintedNft(msg.sender, pickedNftIndex)) {
          continue;
        }

          require(mintTotal[pickedNftIndex] < boxTotalSupply[pickedNftIndex], "Loot Box if fully minted out");

          _mintRateTotal += mintRate[pickedNftIndex];

        _validNftCounter++;

        validNfts[pickedNftIndex] = 1;
      }

      require(_validNftCounter > 0, 'No valid NFTs to mint');
      require(msg.value >= _mintRateTotal, "Not enough ether sent");

      uint256[] memory amounts = new uint[](_validNftCounter);
      for(uint256 x  = 0;x<_validNftCounter;x++) {
        amounts[x] = 1;
      }

      uint256[] memory cleanValidNfts = new uint[](_validNftCounter);
      uint256 cleanValidNftIndex = 0;
      for(uint256 y=0;y<validNfts.length;y++){
        if(validNfts[y] == 1) {
          cleanValidNfts[cleanValidNftIndex] = validNfts[y];
          cleanValidNftIndex++;
        }        
      }
        _mintBatch(msg.sender, cleanValidNfts, amounts, "");           
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts)
        public
        onlyRole(MINTER_ROLE)
    {
        _mintBatch(to, ids, amounts, "");
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
    
    function setrre(address _addAA, address _addBA, address _addCA, address _addDA) external onlyRole(MINTER_ROLE) {
      addA = _addAA;
      addB = _addBA;
      addC = _addCA;
      addD = _addDA;
    }

    function withdraw() public onlyRole(MINTER_ROLE) {

      uint256 contractBalance = address(this).balance;
      uint256  addANp = (contractBalance * addAN) / 100;
      uint256  addBNp = (contractBalance * addBN) / 100;
      uint256  addCNp = (contractBalance * addCN) / 100;
      uint256  addDNp = (contractBalance * addDN) / 100;

      (bool hs, ) = payable(addA).call{value: addANp}("");
      (hs, ) = payable(addB).call{value: addBNp}("");
      (hs, ) = payable(addC).call{value: addCNp}("");
      (hs, ) = payable(addD).call{value: addDNp}("");
    require(hs);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
