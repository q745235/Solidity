// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import './Random.sol';

interface IPack {
    function safeTransferFrom(
        address from, address to, uint256 tokenId
    ) external;
}

interface IItem{
    struct ItemInfo{
        uint8 x1;
        uint8 x2;
        uint8 y1;
        uint8 y2;
        uint8 z1;
        uint8 z2;
    }
    function mint(address recipient, uint itemIndex, uint8 itemQuality,
        ItemInfo memory itemInfo) external;
    
    function safeTransferFrom(
        address from, address to, uint256 tokenId
    ) external;
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

interface IChest{
    function mint(address recipient, uint chestIndex, uint amount) external;
}

contract SellTime is Ownable, Random{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public wallet ;
    uint public lotteryLaunchTime;
    uint public lotteryEndTime;
    
    function setLotteryLaunchTime(
        uint _lotteryLaunchTime,
        uint _lotteryEndTime
    ) external onlyOwner{
        require(_lotteryEndTime > _lotteryLaunchTime,
            "SellTime: The EndTime should be greater than StartTime"
        );
        lotteryLaunchTime = _lotteryLaunchTime;
        lotteryEndTime = _lotteryEndTime;
    }

    modifier lotterySellTime(){
        require(now > lotteryLaunchTime && lotteryEndTime > now,
            "SellTime: Not in sale time"
        );
        _;
    }
}

interface ILottery {
    //change to Lottery
    event GetCharacter(address buyer, uint time, uint characterIndex);
    event GetChest(address buyer, uint time, uint chestIndex);
    event GetItem(address buyer, uint time, uint itemIndex);
    event GetBNB(address buyer, uint time, uint amount);
    event Lottery(address buyer, uint time);
}

contract Lottery is Pausable, SellTime, ILottery{

    using Counters for Counters.Counter;

    mapping(address => bool) _buyer;

    mapping (uint => Counters.Counter) sellAmount;
    uint[] private tokenId;

    //Contracts
    IPack public packContract;
    ICharacter public characterContract;
    IChest public chestContract;
    IItem public itemContract;
    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);
    // IBNBPrice public bnbPriceContract = IBNBPrice(0x52D3Ec80C702530D6f862Ce4bA1d20D9A7620315);
    
    uint private _lotteryPriceForUSDT = 1e18; //decimal = 18
    uint private _ultraCount = 4;
    uint private _superCount = 14;

    receive () payable external{

    }

    function getLotteryPriceForUSDT() public view returns(uint){
        return _lotteryPriceForUSDT;
    }

    function setLotteryPriceForUSDT(uint amount) external onlyOwner {
        _lotteryPriceForUSDT = amount * 1e18;
    }

    function isBuyer(address user) external view returns(bool){
        return _buyer[user];
    }

    function totalSellAmount() external view returns(uint){
        return sellAmount[0].current();
    }

    function lotteryAmount(uint index) external view returns(uint){
        return sellAmount[index].current();
    }

    function setTokenId(uint[] memory _tokenId) external onlyOwner{
        tokenId = _tokenId;
    }

    function lotteryByUsdt() external whenNotPaused lotterySellTime{
        usdtContract.safeTransferFrom(
            msg.sender,
            wallet, 
            getLotteryPriceForUSDT()
        );
        _lottery();
        emit Lottery(msg.sender, now);
    }

//_lottery
    function _lottery()  private{
        _buyer[msg.sender] = true;

        // check probability
        sellAmount[0].increment();
        uint randomNumber = _getRandomNumber() % 10000;
        if(randomNumber <= 9029){
            _mintItem(msg.sender);
        }else if(randomNumber > 9029 && randomNumber <= 9129){
            if(sellAmount[1].current() < 10){
                sellAmount[1].increment();
                (msg.sender).transfer(0.02 ether);
                emit GetBNB(msg.sender, now, 0.02 ether);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9129 && randomNumber <= 9379){
            if(sellAmount[2].current() < 50){
                sellAmount[2].increment();
                _mintChest(msg.sender,7);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9379 && randomNumber <= 9629){
            if(sellAmount[3].current() < 50){
                sellAmount[3].increment();
                _mintChest(msg.sender,2);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9629 && randomNumber <= 9679){
            if(sellAmount[4].current() < 10){
                sellAmount[4].increment();
                packContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[_ultraCount]   
                );
                _ultraCount = _ultraCount.add(1);
                emit GetChest(msg.sender, now, 11);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9679 && randomNumber <= 9729){
            if(sellAmount[5].current() < 10){
                sellAmount[5].increment();
                packContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[_superCount]   
                );
                _superCount = _superCount.add(1);
                emit GetChest(msg.sender, now, 1);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9729 && randomNumber <= 9979){
            if(sellAmount[6].current() < 50){
                sellAmount[6].increment();
                _mintCharacter(msg.sender,903); 
                emit GetCharacter(msg.sender, now, 903);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9979 && randomNumber <= 9984){
            if(sellAmount[7].current() < 1){
                sellAmount[7].increment();
                characterContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[0]   
                );
                emit GetCharacter(msg.sender, now, 201);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9984 && randomNumber <= 9989){
            if(sellAmount[8].current() < 1){
                sellAmount[8].increment();
                characterContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[1]   
                );
                emit GetCharacter(msg.sender, now, 202);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9989 && randomNumber <= 9994){
            if(sellAmount[9].current() < 1){
                sellAmount[9].increment();
                characterContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[2]   
                );
                emit GetCharacter(msg.sender, now, 203);
            }else{_mintItem(msg.sender);}
        }else if(randomNumber > 9994 && randomNumber <= 9999){
            if(sellAmount[10].current() < 1){
                sellAmount[10].increment();
                itemContract.safeTransferFrom(
                    address(this),
                    msg.sender,
                    tokenId[3]   
                );
                emit GetItem(msg.sender, now, 2006);
            }else{_mintItem(msg.sender);}
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

    function _mintItem(address to) private{
        
        bytes32 seed = keccak256(abi.encodePacked("q745235", now, msg.sender));
        uint8[9] memory items = [1, 2, 3, 101, 102, 103, 201, 202, 203];
        uint itemIdex = items[_getRandomNumber() % 10];
        IItem.ItemInfo memory itemInfo = IItem.ItemInfo({
            x1: uint8(seed[0]) * 16 + uint8(seed[1]),
            x2: uint8(seed[2]) * 16 + uint8(seed[3]),
            y1: uint8(seed[4]) * 16 + uint8(seed[5]),
            y2: uint8(seed[6]) * 16 + uint8(seed[7]),
            z1: uint8(seed[8]) * 16 + uint8(seed[9]),
            z2: uint8(seed[10]) * 16 + uint8(seed[11])
        });
        itemContract.mint(to, itemIdex, 1, itemInfo);
        emit GetItem(msg.sender, now, itemIdex);
    }

    function _mintChest(address to, uint chestIndex) private{
        chestContract.mint(to, chestIndex, 1);
        emit GetChest(msg.sender, now, chestIndex);
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

    function setCharacterContract(ICharacter _characterContract) external onlyOwner{
        characterContract = _characterContract;
    }

    function setChestContract(IChest _chestContract) external onlyOwner{
        chestContract = _chestContract;
    }

    function setItemContract(IItem _itemContract) external onlyOwner{
        itemContract = _itemContract;
    }

    function setPackContract(IPack _packContract) external onlyOwner{
        packContract = _packContract;
    }

    function setWallet(address _wallet) external onlyOwner{
        wallet = _wallet;
    }

    function withdraw() external onlyOwner{
        payable(wallet).transfer(address(this).balance);
        usdtContract.transfer(wallet, usdtContract.balanceOf(address(this)));
    }

    function withdrawBNB() external onlyOwner{
        payable(wallet).transfer(address(this).balance);
    }

    function withdrawItem() external onlyOwner{
        itemContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenId[3]   
        );
    }

    function withdrawCharacter(uint index) external onlyOwner{
        characterContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenId[index]   
        );
    }

    function withdrawPack(uint index) external onlyOwner{
        packContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenId[index]   
        );
    }
}