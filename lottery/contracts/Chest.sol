// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Random.sol";
import "./Miner.sol";
interface IItem2 is IERC721{

    struct ItemInfo{
        uint8 x1;
        uint8 x2;
        uint8 y1;
        uint8 y2;
        uint8 z1;
        uint8 z2;
    }

    function mint(
        address recipient,
        uint itemIndex,
        uint8 itemQuality,
        ItemInfo memory itemInfo
    ) external;
    
}

interface IOpenChest {
    event Open(address indexed owner);
}

contract Chest is Miner, ERC1155, Random{
    IItem2 public itemContract;
    // IChest public chestContract;
    
    mapping (uint => bool) private _canOpen; //chestIndex => chest canOpen
    mapping (uint => uint) private _chestAmount; //chestIndex => chestAmount
    mapping (uint => ItemItem[]) private _chestItem; //chestIndex => chestItem
    mapping (uint => string[]) private _chestProbability; //chestIndex =>
    mapping (uint => string) private _chestURI; //chestIndex => chestURI

    struct ItemItem{
        uint itemIndex;
        uint8 itemQuality;
        uint probability;
    }

    // mint Chest

    mapping (uint => uint) private _nftCount; //chestIndex => count

    constructor() public ERC1155("https://q745235/{id}.json") {}

    function chestCount(uint chestIndex) public view returns(uint){
        return _nftCount[chestIndex];
    }

    function mint(address recipient, uint chestIndex, uint amount) external onlyMiner{
        _mint(recipient, chestIndex, amount, "");
        _nftCount[chestIndex] = _nftCount[chestIndex].add(amount);

    }

    function mintBatch(address recipient, uint[] memory chestIndex, uint[] memory amount) external onlyMiner{
        _mintBatch(recipient, chestIndex, amount, "");
        for (uint i = 0; i < chestIndex.length; i++) {
            _nftCount[chestIndex[i]] = _nftCount[chestIndex[i]].add(amount[i]);
        }
    }

    string private _baseURI;
    function baseURI() public view virtual returns (string memory) {
        return _baseURI;
    }

    function setBaseURI(string memory _newURI) external onlyOwner{
        _baseURI = _newURI;
    }

    function uri(uint256 chestIndex) public  view override  returns (string memory) {
        string memory base = baseURI();
        return string(abi.encodePacked(base, _chestURI[chestIndex]));
    }

    function tokenURI(uint256 chestIndex) public view returns (string memory) {
        return uri(chestIndex);
    }
    
    function setChestURI(uint chestIndex, string memory chestURI) external onlyOwner {
        _chestURI[chestIndex] = chestURI;
    } 

    function setUri(string memory newuri)  external onlyOwner {
        _setURI(newuri);
    }


    // open Chest
    function isCanOpen(uint chestIndex) public view returns(bool){
        return _canOpen[chestIndex];
    }

    function setOpen(uint chestIndex, bool tf) public onlyOwner{
        _canOpen[chestIndex] =tf;
    }

    // Set item probability
    function setChestItem (uint chestIndex, uint itemIndex, uint8 itemQuality, uint probability) external onlyOwner{
        _chestItem[chestIndex].push(ItemItem(itemIndex, itemQuality, probability));
    }

    function chestItem (uint chestIndex) view public returns(ItemItem[] memory) {
        return _chestItem[chestIndex];
    }

    function initChestItem(uint chestIndex) external onlyOwner{
        ItemItem[] storage newArray;
        _chestItem[chestIndex] = newArray;
    }

    function chestProbability (uint chestIndex) view public returns(string[] memory) {
        return _chestProbability[chestIndex];
    }

    // Set chest probability (str)

    function initChestProbability(uint chestIndex) external onlyOwner{
        string[] storage newArray;
        _chestProbability[chestIndex] = newArray;
    }

    function setChestProbability (uint chestIndex, string memory probability) external onlyOwner{
        _chestProbability[chestIndex].push(probability);
    }

    // Set item amount
    function setChestAmount(uint chestIndex, uint amount) external onlyOwner{
        _chestAmount[chestIndex] = amount;
    }

    function chestAmount(uint chestIndex) view public returns(uint) {
        return _chestAmount[chestIndex];
    }

    function openChest(uint chestIndex, uint amount) external{
        require(amount > 0, "Amount must more than zero");
        require(balanceOf(msg.sender,chestIndex) >= amount, "You need more chests");
        require(isCanOpen(chestIndex), "Cannot open now");
        //Destroy chest
        _burn(msg.sender,chestIndex,
            amount);
        require(_chestAmount[chestIndex] > 0, "chestLen must more than zero");
        for (uint j = 0; j < amount; j++){
            for (uint256 i = 0; i < _chestAmount[chestIndex]; i++) {_openChest(chestIndex);}
        }
    }

    function _openChest(uint chestIndex)  private{
        ItemItem[] memory newChestItem = chestItem(chestIndex);
        uint itemProbability = 0;
        uint allProbability = 0;
        // check probability
        for (uint256 j = 0; j < newChestItem.length; j++){
            allProbability = allProbability.add(newChestItem[j].probability);
        }
        uint randomNumber = _getRandomNumber() % allProbability;
        for (uint256 i = 0; i < newChestItem.length; i++){
            itemProbability = itemProbability.add(newChestItem[i].probability);
            if(itemProbability >= randomNumber){
                _mintItem(
                    msg.sender, 
                    newChestItem[i].itemQuality, 
                    newChestItem[i].itemIndex
                );
                break;
            }
        }
    }

    function _mintItem(
        address to,
        uint8 itemQuality,
        uint itemIndex
    ) private{
        
        bytes32 seed = keccak256(abi.encodePacked("NFTs Battle", now, msg.sender));

        IItem2.ItemInfo memory itemInfo = IItem2.ItemInfo({
            x1: uint8(seed[0]) * 16 + uint8(seed[1]),
            x2: uint8(seed[2]) * 16 + uint8(seed[3]),
            y1: uint8(seed[4]) * 16 + uint8(seed[5]),
            y2: uint8(seed[6]) * 16 + uint8(seed[7]),
            z1: uint8(seed[8]) * 16 + uint8(seed[9]),
            z2: uint8(seed[10]) * 16 + uint8(seed[11])
        });

        itemContract.mint(to, itemIndex, itemQuality, itemInfo);
    }

    function setItemCardContract(IItem2 _ItemContract) external onlyOwner{
        itemContract = _ItemContract;
    }
}