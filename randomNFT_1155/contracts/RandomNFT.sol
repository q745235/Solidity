// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import './Random.sol';
import './Miner.sol';

contract SellTime is Miner{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public OneWallet;
    address public TwoWallet;
    address public ThreeWallet;
    address public RandomNFTWallet;
    uint public purchaseTime = 1650585600;// 2022/4/22 08:00
    uint public purchaseEnd = 9999999999;
    
    function setPurchaseTime(
        uint _purchaseTime,
        uint _purchaseEnd
    ) external onlyOwner{
        purchaseTime = _purchaseTime;
        purchaseEnd = _purchaseEnd;
    }

    modifier purchase(){
        require(now > purchaseTime && purchaseEnd > now,
            "SellTime: Not in sale time"
        );
        _;
    }

}

interface IChips {
    event BuyChips(address buyer, uint time,uint chipsIndex, uint amount);
    function buyChipsByUsdt() external;
}

contract RandomNFT is Pausable, SellTime, IChips, Random, ERC1155{

    using Counters for Counters.Counter;
    mapping(address => bool) _buyer;
    mapping(address => bool) _whitelist;
    bool public _openWhitelist = true;

    uint public totalSellAmount = 10000;
    uint public permitSellAmount = 100;

    mapping (uint => uint) private _nftCount;

    uint public jpg1 = 990;
    uint public jpg2 = 10;
    uint public limit = 3;
    //Contracts

    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);

    uint private _priceForUSDT = 100e18; //decimal = 18

    string private _baseURI;
    mapping (uint => string) private _chipsURI;

    string private _name;
    string private _symbol;
    constructor() public ERC1155("https://q745235/randomNFT/1155/{id}.json") {
        _baseURI = 'https://q745235/randomNFT/1155/';
        _chipsURI[1] = '1.json';
        _chipsURI[2] = '2.json';
        _name = "Two RandomNFT";
        _symbol = "MH";
    }

    function setApprovalForAll(
        address operator, bool approved
    ) override public{
        if(_openWhitelist){
            require(isWhitelist(operator), "The address is not on whitelist");
        }
        super.setApprovalForAll(operator, approved);
    }

    function setOpenWhitelist(bool tf) external onlyOwner{
        _openWhitelist = tf;
    }

    function setWhitelist(address _address, bool tf) external onlyOwner{
        _whitelist[_address] = tf;
    }

    function isWhitelist(address _address) view public returns(bool){
        return _whitelist[_address];
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }


    function getPriceForUSDT() public view returns(uint){
        return _priceForUSDT;
    }

    function isBuyer(address user) external view returns(bool){
        return _buyer[user];
    }


    function chipsCount(uint chipsIndex) public view returns(uint){
        return _nftCount[chipsIndex];
    }

    function getChipsIndex() private returns(uint){
        uint allAmount = permitSellAmount;
        uint randomNumber = (_getRandomNumber() % allAmount).add(1);
        if(randomNumber > (permitSellAmount.sub(jpg2))){
            jpg2 = jpg2.sub(1);
            return 2;
        }else{
            jpg1 = jpg1.sub(1);
            return 1;
        }
    }

    function buyChipsByUsdt(
        
    ) override external whenNotPaused purchase{
        require(_nftCount[0] < totalSellAmount, "Chips sold out!");
        require(permitSellAmount > 0, "You should buy chips next time");

        usdtContract.safeTransferFrom(
            msg.sender,
            OneWallet,
            getPriceForUSDT().div(100).mul(2)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            TwoWallet,
            getPriceForUSDT().div(100).mul(2)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            ThreeWallet,
            getPriceForUSDT().div(100).mul(1)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            RandomNFTWallet,
            getPriceForUSDT()
        );
        
        uint chipsIndex = getChipsIndex();
        permitSellAmount = permitSellAmount.sub(1);
        _buyChips();
        _mintToken(msg.sender, chipsIndex, 1);
    }

    function buyChipsBatchByUsdt(
        uint amount
    ) external whenNotPaused purchase{
        require(_nftCount[0].add(amount) <= totalSellAmount, "Chips sold out!");
        require(permitSellAmount.sub(amount) >= 0, "You should buy chips next time");
        require(amount <= limit, "You mint over!");

        usdtContract.safeTransferFrom(
            msg.sender,
            OneWallet,
            getPriceForUSDT().mul(amount).div(100).mul(2)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            TwoWallet,
            getPriceForUSDT().mul(amount).div(100).mul(2)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            ThreeWallet,
            getPriceForUSDT().mul(amount).div(100).mul(1)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            RandomNFTWallet,
            getPriceForUSDT().mul(amount)
        );
        uint[] memory indexs = new uint[](2);
        indexs[0] = 1;
        indexs[1] = 2;
        uint[] memory chipsAmount = new uint[](2);
        for (uint i = 0; i < amount; i++){
            uint chipsIndex = getChipsIndex();
            if(chipsIndex == 1){
                chipsAmount[0] = chipsAmount[0].add(1);
            }else if(chipsIndex == 2){
                chipsAmount[1] = chipsAmount[1].add(1);
            }
        }
        permitSellAmount = permitSellAmount.sub(amount);
        _buyChips();
        _mintTokenBatch(msg.sender, indexs, chipsAmount);
    }

//_buy

    function _buyChips() private{
        _buyer[msg.sender] = true;
    }

//_mint

    function mint(address recipient, uint chipsIndex, uint amount) public onlyMiner{
        _mintToken(recipient, chipsIndex, amount);
    }

    function mintBatch(
        address recipient, uint[] memory chipsIndex, uint[] memory amount
    ) public onlyMiner{
        _mintTokenBatch(recipient,chipsIndex,amount);
    }

    function _mintToken(address recipient, uint chipsIndex, uint amount) internal{
        _mint(recipient, chipsIndex, amount, "");
        _nftCount[chipsIndex] = _nftCount[chipsIndex].add(amount);
        emit BuyChips(recipient, now, chipsIndex, amount);
    }

    function _mintTokenBatch(
        address recipient, uint[] memory chipsIndex, uint[] memory amount
    ) internal{
        _mintBatch(recipient, chipsIndex, amount, "");
        for (uint i = 0; i < chipsIndex.length; i++) {
            _nftCount[chipsIndex[i]] = _nftCount[chipsIndex[i]].add(amount[i]);
            emit BuyChips(recipient, now, chipsIndex[i], amount[i]);
        }
    }
//URI

function baseURI() public view virtual returns (string memory) {
        return _baseURI;
    }

function setBaseURI(string memory _newURI) external onlyOwner{
        _baseURI = _newURI;
    }

function uri(uint256 chipsIndex) public  view override  returns (string memory) {
    string memory base = baseURI();
    return string(abi.encodePacked(base, _chipsURI[chipsIndex]));
}

function tokenURI(uint256 chipsIndex) public view returns (string memory) {
    return uri(chipsIndex);
}

function setChestURI(uint chipsIndex, string memory chipsURI) external onlyOwner {
    _chipsURI[chipsIndex] = chipsURI;
} 

function setUri(string memory newuri)  external onlyOwner {
    _setURI(newuri);
}

//onlyOwner
    function setPuase() external onlyOwner{
        _pause();
    }

    function setUnpuase() external onlyOwner{
        _unpause();
    }

    function setTotalSellAmount(uint amount) external onlyOwner{
        totalSellAmount = amount;
    }

    function setPermitSellAmount(uint amount) external onlyOwner{
        permitSellAmount = amount;
    }

    function setJpg1(uint amount) external onlyOwner{
        jpg1 = amount;
    }

    function setJpg2(uint amount) external onlyOwner{
        jpg2 = amount;
    }

    function setLimit(uint amount) external onlyOwner{
        limit = amount;
    }

    function setNewPermitSell(
        uint _Ppermit, uint _jpg1, uint _jpg2
    ) external onlyOwner{
        require(_Ppermit==(_jpg1.add(_jpg2)),"numeric error exception");
        permitSellAmount = _Ppermit;
        jpg1 = _jpg1;
        jpg2 = _jpg2;
    }

    function setOneWallet(address _wallet) external onlyOwner{
        OneWallet = _wallet;
    }

    function setTwoWallet(address _wallet) external onlyOwner{
        TwoWallet = _wallet;
    }

    function setThreeWallet(address _wallet) external onlyOwner{
        ThreeWallet = _wallet;
    }

    function setRandomNFTWallet(address _wallet) external onlyOwner{
        RandomNFTWallet = _wallet;
    }

    function setUsdtContract(IERC20 _usdtContract) external onlyOwner{
        usdtContract = _usdtContract;
    }

    function withdraw() external onlyOwner{
        payable(OneWallet).transfer(address(this).balance);
        usdtContract.transfer(OneWallet, usdtContract.balanceOf(address(this)));
    }

    function setPriceForUSDT(uint amount) external onlyOwner {
        _priceForUSDT = amount;
    }
//
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        _burn(account, id, value);
    }

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        _burnBatch(account, ids, values);
    }
    
}