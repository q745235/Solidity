// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Miner.sol';
import './Random.sol';

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SellTime is Miner{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    uint public sellStartTime = 1648695600;//"2022/3/31 21:00": 1648731600
    uint public sellEndTime = 8643990400; //1643990400

    function setSellTime(
        uint _sellStartTime,
        uint _sellEndTime
    ) external onlyOwner{
        sellStartTime = _sellStartTime;
        sellEndTime = _sellEndTime;
    }

    modifier sellTime(){
        require(now > sellStartTime && sellEndTime > now,
            "SellTime: Not in sale time"
        );
        _;
    }
}
    
contract RandomNFT is SellTime, ERC721, Pausable, Random {
    using Counters for Counters.Counter;
    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);
    
    mapping (uint => Counters.Counter) private _nftCount; //randomNFTIndex => count
    mapping (uint => string) private _randomNFTURI;
    mapping(address => bool) _buyer;
    mapping(address => bool) _whitelist;

    address public OneWallet = 0x3A5d7eFf1FF7835d36CB3A370928F177779A2c18;
    address public TwoWallet = 0xdD4c24268cC4D134B9185b92701d3158130ED156;
    address public ThreeWallet = 0x65d98663a0AcB3B1B326DdD30E8b254BD6755C6E;
    address public RandomNFTWallet = 0xE99635818A71E5e24dba64d30216ec535b310a0d;

    uint public totalSellAmount = 1000;
    uint public permitSellAmount = 200;
    uint public gold = 3;
    uint public silver = 10;
    uint public copper = 187;

    uint private _priceForUSDT = 150e18;

    event BuyRandomNFTNFT(address recipient,uint time, uint tokenId, uint randomNFTIndex);

    constructor() public ERC721("RandomNFT NFT", "IQN") {
        _setBaseURI('https://q745235/randomNFT/');
    }

    function setApprovalForAll(
        address operator, bool approved
    ) override public{
        require(isWhitelist(operator), "The address is not on whitelist");
        super.setApprovalForAll(operator, approved);
    }

    function setWhitelist(address _address, bool tf) external onlyOwner{
        _whitelist[_address] = tf;
    }

    function isWhitelist(address _address) view public returns(bool){
        return _whitelist[_address];
    }

    function getPriceForUSDT() public view returns(uint){
        return _priceForUSDT;
    }

    function isBuyer(address user) public view returns(bool){
        return _buyer[user];
    }

    function getRandomNFTIndex() private returns(uint){
        uint allAmount = permitSellAmount;
        uint randomNumber = (_getRandomNumber() % allAmount).add(1);
        if(randomNumber > (permitSellAmount.sub(gold))){
            gold = gold.sub(1);
            return 3;
        }else if(randomNumber > (permitSellAmount.sub(gold).sub(silver))){
            silver = silver.sub(1);
            return 2;
        }else{
            copper = copper.sub(1);
            return 1;
        }
    }

    function buyRandomNFTbyUsdt() external whenNotPaused sellTime {

        require(_nftCount[0].current() < totalSellAmount, "RandomNFT sold out!");
        require(permitSellAmount > 0, "You should buy RandomNFT next time!");
        
        usdtContract.safeTransferFrom(
            msg.sender,
            TwoWallet,
            getPriceForUSDT().div(100).mul(12)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            OneWallet,
            getPriceForUSDT().div(100).mul(12)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            ThreeWallet,
            getPriceForUSDT().div(100).mul(6)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            RandomNFTWallet,
            getPriceForUSDT().div(100).mul(70)
        );
        uint cardIndex = getRandomNFTIndex();
        permitSellAmount = permitSellAmount.sub(1);
        _mintToken(msg.sender, cardIndex);
        _buyer[msg.sender] = true;
        
    }

    function randomNFTCount(uint index) public view returns(uint){
        return _nftCount[index].current();
    }

    function mint(address recipient, uint randomNFTIndex) external onlyMiner{
        require(_nftCount[0].current() < totalSellAmount, "RandomNFT sold out!");
        _mintToken(recipient, randomNFTIndex);
    }

    function _mintToken(address recipient, uint randomNFTIndex) internal{
        _nftCount[0].increment();
        _nftCount[randomNFTIndex].increment();
        uint tokenId = randomNFTIndex.mul(1000).add(randomNFTCount(randomNFTIndex));
        _mint(recipient, tokenId);
        string memory i = uintToString(tokenId);
        _randomNFTURI[tokenId] = string(abi.encodePacked( string(i), ".json"));
        emit BuyRandomNFTNFT(recipient, now, tokenId, randomNFTIndex);
    }

    function burn(uint tokenId) external{
        require(ownerOf(tokenId) == msg.sender, "You are not this token owner");
        _burn(tokenId);
    }

    function randomNFTURI(uint tokenId) public view returns(string memory) {
        return _randomNFTURI[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory base = baseURI();

        // If there is no base URI, return the ticket URI.
        if (bytes(base).length == 0) {
            return randomNFTURI(tokenId);
        }
        // If both are set, concatenate the baseURI and randomNFTURI (via abi.encodePacked).
        if (bytes(randomNFTURI(tokenId)).length > 0) {
            return string(abi.encodePacked(base, randomNFTURI(tokenId)));
        }
        // If there is a baseURI but no randomNFTURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setRandomNFTURI(uint tokenId, string memory URI) external onlyOwner{
        _randomNFTURI[tokenId] = URI;
    }

    function setTotalSellAmount(uint amount) external onlyOwner{
        totalSellAmount = amount;
    }

    function setPermitSellAmount(uint amount) external onlyOwner{
        permitSellAmount = amount;
    }

    function setGold(uint amount) external onlyOwner{
        gold = amount;
    }

    function setSilver(uint amount) external onlyOwner{
        silver = amount;
    }

    function setCopper(uint amount) external onlyOwner{
        copper = amount;
    }

    function setNewSell(
        uint _permitSell, uint _gold, uint _silver, uint _normal
    ) external onlyOwner{
        require(
            _permitSell == (_gold.add(_silver).add(_normal)),
            "numeric error exception"
        );
        permitSellAmount = _permitSell;
        gold = _gold;
        silver = _silver;
        copper = _normal;
    }

    function setOneWallet(address wallet) external onlyOwner{
        OneWallet = wallet;
    }

    function setTwoWallet(address wallet) external onlyOwner{
        TwoWallet = wallet;
    }

    function setThreeWallet(address wallet) external onlyOwner{
        ThreeWallet = wallet;
    }

    function setRandomNFTWallet(address wallet) external onlyOwner{
        RandomNFTWallet = wallet;
    }

    function setPriceForUSDT(uint amount) external onlyOwner {
        _priceForUSDT = amount;
    }

    function setUsdtContract(IERC20 newContract) external onlyOwner {
        usdtContract = newContract;
    }

// uint to string
    function uintToString(uint u) public pure returns (string memory str) {
        uint _u = u;
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (_u != 0) {
            uint remainder = _u % 10;
            _u = _u / 10;
            reversed[i++] = byte(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        str = string(s);
    }
}