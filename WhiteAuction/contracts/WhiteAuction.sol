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
    uint public auctionStartTime = 1646444800;// 2022/3/21 20:00
    uint public auctionEndTime = 1646531200;// 2022/3/22 20:00
    
    function setAuctionTime(
        uint _auctionStartTime,
        uint _auctionEndTime
    ) external onlyOwner{
        auctionStartTime = _auctionStartTime;
        auctionEndTime = _auctionEndTime;
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

contract WhiteAuction is Pausable, AuctionTime, ITwo{

    using Counters for Counters.Counter;
    mapping(address => bool) _buyer;
    mapping(address => bool) _customer;

    mapping (uint => Counters.Counter) private auctionAmount;

    //Contracts

    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);
    ICharacter public characterContract;
    uint private _priceForUSDT = 80e18; //decimal = 18

    function getPriceForUSDT() public view returns(uint){
        return _priceForUSDT;
    }

    function isBuyer(address user) public view returns(bool){
        return _buyer[user];
    }

    function isCustomer(address user) public view returns(bool){
        return _customer[user];
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

    function winTheBidByUsdt(
        
    ) override external whenNotPaused auctionTime{
        require(totalAuctionAmount() < 20, "Auction has ended.");
        require(isCustomer(msg.sender), "You are not on whitelist.");
        require(!isBuyer(msg.sender), "You already have one.");
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
        uint normalItem = 19;
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

    function setCustomer(address[] memory _address,bool tf) external onlyOwner{
        for(uint i = 0 ;i< _address.length;i++){
            _customer[_address[i]] = tf;
        }
    }
}