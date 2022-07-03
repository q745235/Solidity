// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Miner.sol';
import './Random.sol';
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/utils/Counters.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBNBPrice {
    function GetBNBPrice() external view returns(uint);
    function GetBNBAmountFromUSDTAmount(uint USDTAmount) external view returns(uint);
    function GetUSDTAmountFromBNBAmount(uint BNBAmount) external view returns(uint);
}

contract SellTime is Miner{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    uint public sellStartTime = 1643644800;//"2022/2/1"
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
    
contract Surprise is SellTime, ERC721, Pausable, Random {
    using Counters for Counters.Counter;
    IERC20 public USDTContract = IERC20(0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684);
    IERC20 public WBWBContract = IERC20(0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd);
    address public CakePair_USDT_WBNB = 0xF855E52ecc8b3b795Ac289f85F6Fd7A99883492b;

    mapping (uint => uint) private _surpriseIndex; //tokenId => surpriseIndex
    
    Counters.Counter private _nftCount; //surpriseIndex => count
    mapping (uint => string) private _surpriseURI; //surpriseIndex => URI;
    mapping (address => bool) private _alreadyBought;

    address private oneAddress ;
    address private twoAddress ;
    address private threeAddress ;

    uint public luckyTime = 1643990400; // "2022/2/5"
    uint private luckySurprise = (_getRandomNumber() % 50).add(100);
    uint public luckySurpriseIndex = 2;
    uint allAmount = 50;
    uint public _priceForUSDT = 2.5e18;

    event Receive(uint time, uint tokenId);

    constructor() public ERC721("q745235", "Surprise") {
    }

    function GetBNBAmountFromUSDTAmount(uint USDTAmount) public view whenNotPaused returns(uint){
        uint WBNBAmountOfCakePair = WBWBContract.balanceOf(CakePair_USDT_WBNB);
        //Get WBNB balances from CakePair
        uint USDTAmountOfCakePair = USDTContract.balanceOf(CakePair_USDT_WBNB);
        //Get USDT balances from CakePair
        uint BNBPriceFromCake = (USDTAmountOfCakePair).div(WBNBAmountOfCakePair);
        return USDTAmount.div(BNBPriceFromCake);
        //Input and Output are have 18 decimals
    }

    function GetBNBAmount() public view returns(uint){
        return GetBNBAmountFromUSDTAmount(_priceForUSDT);
    }

    function receiveSurprise() payable external whenNotPaused sellTime {
        if(_alreadyBought[msg.sender]){
            revert("You have already bought!");
        }

        require(_nftCount.current() < allAmount, "Surprise sold out!");
        
        require(msg.value >= GetBNBAmount().mul(97).div(100),
            "The payment is not enough!"
        );
        //allow a little bit deviation
        payable(oneAddress).transfer(msg.value.mul(2).div(5));
        payable(twoAddress).transfer(msg.value.mul(2).div(5));
        payable(threeAddress).transfer(msg.value.div(5));
        _mintToken(msg.sender, 1);
        _alreadyBought[msg.sender] = true;
        
    }

    function surpriseCount() public view returns(uint){
        return _nftCount.current();
    }

    function tokenId2Surprise(uint tokenId) public view returns(uint){
        return _surpriseIndex[tokenId];
    }

    function mint(address recipient, uint surpriseIndex) external onlyMiner{
        _mintToken(recipient, surpriseIndex);
    }

    function _mintToken(address recipient, uint surpriseIndex) internal{
        _nftCount.increment();
        uint tokenId = surpriseIndex.mul(100).add(surpriseCount());
        _surpriseIndex[tokenId] = surpriseIndex;
        _mint(recipient, tokenId);
        emit Receive(now, tokenId);
    }

    function burn(uint tokenId) external{
        require(ownerOf(tokenId) == msg.sender, "You are not this token owner");
        _burn(tokenId);
    }

    function surpriseURI(uint surpriseIndex) public view returns(string memory) {
        return _surpriseURI[surpriseIndex];
    }

    function luckySurpriseURI() public view returns(string memory) {
        return _surpriseURI[luckySurpriseIndex];
    }

    function luckySurpriseTokenId() public view returns(uint) {
        if(now >= luckyTime){
            return luckySurprise;
        }else{
            return 0;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        uint surpriseIndex = tokenId2Surprise(tokenId);

        string memory base = baseURI();

        // If there is no base URI, return the surprise URI.
        if (bytes(base).length == 0) {
            return surpriseURI(surpriseIndex);
        }
        // If both are set, concatenate the baseURI and surpriseURI (via abi.encodePacked).
        if (bytes(surpriseURI(surpriseIndex)).length > 0) {
            if(now > luckyTime && tokenId == luckySurprise){
                return string(abi.encodePacked(base, surpriseURI(luckySurpriseIndex)));
            }
            return string(abi.encodePacked(base, surpriseURI(surpriseIndex)));
        }
        // If there is a baseURI but no surpriseURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setSurpriseIndexURI(uint surpriseIndex, string memory URI) external onlyOwner{
        _surpriseURI[surpriseIndex] = URI;
    }

    function setLuckySurpriseIndex(uint _luckySurpriseIndex) external onlyOwner{
        luckySurpriseIndex = _luckySurpriseIndex;
    }

    function setLuckyTime(
        uint _luckyTime
    ) external onlyOwner{
        luckyTime = _luckyTime;
    }

    function setAllAmount(uint amount) external onlyOwner{
        allAmount = amount;
    }

    function setOneWallet(address wallet) external onlyOwner{
        oneAddress = wallet;
    }

    function setTwoWallet(address wallet) external onlyOwner{
        twoAddress = wallet;
    }

    function setThreeWallet(address wallet) external onlyOwner{
        threeAddress = wallet;
    }

    function setPriceForUSDT(uint amount) external onlyOwner {
        _priceForUSDT = amount;
    }

    function setWBWBContract(IERC20 newContract) external onlyOwner {
        WBWBContract = newContract;
    }

    function setUSDTContract(IERC20 newContract) external onlyOwner {
        USDTContract = newContract;
    }
}