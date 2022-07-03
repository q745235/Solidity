// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import './Random.sol';

contract AuctionTime is Ownable, Random{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public OneWallet;
    address public TwoWallet;
    uint public auctionStartTime = 1645185600;// 2022/2/18 20:00
    uint public auctionEndTime = 9999999999;
    uint public dutchAuctionTime = auctionStartTime;
    uint public endAuctionTime = auctionStartTime.add(1200);
    
    function setAuctionTime(
        uint _auctionStartTime,
        uint _auctionEndTime
    ) external onlyOwner{
        auctionStartTime = _auctionStartTime;
        auctionEndTime = _auctionEndTime;
        dutchAuctionTime = _auctionStartTime;
        endAuctionTime = _auctionStartTime.add(1200);
    }

    modifier auctionTime(){
        require(now > auctionStartTime && auctionEndTime > now,
            "auctionTime: Not in auction time"
        );
        _;
    }

}

interface ICharacter{
    struct CharacterInfo{
        uint8 HPbase;
        uint8 ATKbase;
        uint8 DEFbase;
        uint8 LUKbase;
    }

    function mint(
        address recipient, uint characterIndex, CharacterInfo memory characterInfo
    ) external;

    function safeTransferFrom(
        address from, address to, uint256 tokenId
    ) external;
}

interface ITwo {
    event WinTheBid(address buyer, uint time, uint tokenId, uint price);
    function winTheBidByUsdt() external;
}

contract DutchAuction is Pausable, AuctionTime, ITwo{

    using Counters for Counters.Counter;
    mapping(address => bool) _buyer;

    mapping (uint => Counters.Counter) private auctionAmount;
    mapping (uint => uint) private auctionPrice;

    //Contracts

    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);
    ICharacter public characterContract;
    uint private _priceForUSDT = 300e18; //decimal = 18
    uint reducePrice = 10e18;
    uint reduceTime = 60;
    uint lowestPrice = _priceForUSDT;
    uint highestPrice = 0;
    uint totalAuction = 0;

    function getPriceForUSDT() public view returns(uint){
        uint newtime = now.sub(dutchAuctionTime);
        uint off = newtime.div(reduceTime);
        uint overtime = _priceForUSDT.div(reducePrice);
        if(off > overtime){
            off = overtime;
        }
        uint newPrice = _priceForUSDT.sub(reducePrice.mul(off));
        if (newPrice > _priceForUSDT){
            newPrice = _priceForUSDT;
        }
        return newPrice;
    }

    function getLowestPrice() public view returns(uint){
        return lowestPrice;
    }

    function getHighestPrice() public view returns(uint){
        return highestPrice;
    }

    function getAuctionPrice(uint acution) public view returns(uint){
        return auctionPrice[acution];
    }

    function getTotalAuction() public view returns(uint){
        return totalAuction;
    }

    function isBuyer(address user) public view returns(bool){
        return _buyer[user];
    }

    function totalAuctionAmount() public view returns(uint){
        return auctionAmount[0].current();
    }

    function normalAuctionAmount() public view returns(uint){
        return auctionAmount[1].current();
    }

    function specialAuctionAmount() public view returns(uint){
        return auctionAmount[2].current();
    }

    function getAuctionTime() public view returns(uint){
        return dutchAuctionTime;
    }

    function getEndAuctionTime() public view returns(uint){
        return endAuctionTime;
    }

    function winTheBidByUsdt(
        
    ) override external whenNotPaused auctionTime{
        require(totalAuctionAmount() < 20, "Auction has ended");
        require(!isBuyer(msg.sender), "You already bought");
        uint lastPrice = getPriceForUSDT();
        auctionAmount[0].increment();
        usdtContract.safeTransferFrom(
            msg.sender,
            OneWallet,
            lastPrice.div(100).mul(40)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            TwoWallet,
            lastPrice.div(100).mul(60)
        );
        _winningBidder();
        _winTheBid(lastPrice);
    }

//_buy

    function _winningBidder() private{
        _buyer[msg.sender] = true;
    }

//_winTheBid

    function _winTheBid(uint lastPrice) private{
        uint allItem = 20;
        uint normalItem = 17;
        uint characterIndex = 105;
        uint allAmount = allItem.sub(normalAuctionAmount()).sub(specialAuctionAmount());
        uint randomNumber = (_getRandomNumber() % allAmount).add(1);
        if(randomNumber > (normalItem.sub(normalAuctionAmount()))){
            characterIndex = 106;
            auctionAmount[2].increment();
        }else{
            auctionAmount[1].increment();
        }
        _mintCharacter(msg.sender, characterIndex);
        emit WinTheBid(msg.sender, now, characterIndex, lastPrice);
        auctionPrice[totalAuctionAmount()] = lastPrice;
        totalAuction = totalAuction.add(lastPrice);
        if(lowestPrice > lastPrice){
            lowestPrice = lastPrice;
        }
        if(highestPrice < lastPrice){
            highestPrice = lastPrice;
        }
    }

//_mint

    function _mintCharacter(address to, uint characterIndex) private{
        
        bytes32 seed = keccak256(abi.encodePacked("NFTs Battle", now, msg.sender));
        
        uint hpInit = (uint8(seed[0]) * 16 + uint8(seed[1]));
        uint atkInit = (uint8(seed[2]) * 16 + uint8(seed[3]));
        uint defInit = (uint8(seed[4]) * 16 + uint8(seed[5]));
        uint lukInit = (uint8(seed[6]) * 16 + uint8(seed[7]));

        uint normalization = hpInit.add(atkInit).add(defInit).add(lukInit);
        
        ICharacter.CharacterInfo memory characterInfo = ICharacter.CharacterInfo({
            HPbase: uint8(hpInit.mul(100).div(normalization)),
            ATKbase: uint8(atkInit.mul(100).div(normalization)),
            DEFbase: uint8(defInit.mul(100).div(normalization)),
            LUKbase: uint8(lukInit.mul(100).div(normalization))
        });

        characterContract.mint(to, characterIndex, characterInfo);
    }

//onlyOwner
    function setPuase() external onlyOwner{
        _pause();
    }

    function setUnpuase() external onlyOwner{
        _unpause();
    }

    function setUsdtContract(IERC20 _usdtContract) external onlyOwner{
        usdtContract = _usdtContract;
    }

    function setOneWallet(address _wallet) external onlyOwner{
        OneWallet = _wallet;
    }

    function setTwoWallet(address _wallet) external onlyOwner{
        TwoWallet = _wallet;
    }

    function setCharacterContract(ICharacter _characterContract) external onlyOwner{
        characterContract = _characterContract;
    }

    function withdraw() external onlyOwner{
        payable(OneWallet).transfer(address(this).balance);
        usdtContract.transfer(OneWallet, usdtContract.balanceOf(address(this)));
    }

    function setPriceForUSDT(uint amount) external onlyOwner {
        _priceForUSDT = amount;
    }

    function setReducePrice(uint amount) external onlyOwner {
        reducePrice = amount;
    }

    function setReduceTime(uint _time) external onlyOwner {
        reduceTime = _time;
    }

}