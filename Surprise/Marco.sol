// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IBNBPrice {
    function GetBNBPrice() external view returns(uint);
    function GetBNBAmountFromUSDTAmount(uint USDTAmount) external view returns(uint);
    function GetUSDTAmountFromBNBAmount(uint BNBAmount) external view returns(uint);
}

contract SellTime is Ownable{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public BitapeWallet = 0xdD4c24268cC4D134B9185b92701d3158130ED156;
    address public MarcoWallet = 0xEC4dDD0C76AAf2278387726482127F87781473A0;
    address public ArtistWallet = 0xEC4dDD0C76AAf2278387726482127F87781473A0;
    address public ClubWallet = 0x65d98663a0AcB3B1B326DdD30E8b254BD6755C6E;
    uint public ticketSellStartTime = 1637337600;
    uint public ticketSellEndTime = 9999999999;
    
    function setTicketSellTime(
        uint _ticketSellStartTime,
        uint _ticketSellEndTime
    ) external onlyOwner{
        ticketSellStartTime = _ticketSellStartTime;
        ticketSellEndTime = _ticketSellEndTime;
    }

    modifier ticketSellTime(){
        require(now > ticketSellStartTime && ticketSellEndTime > now,
            "SellTime: Not in sale time"
        );
        _;
    }

}

interface IPreSale2 {
    event BuyTicket(address buyer, uint time, uint tokenId);
    function buyTicketByUsdt() external;
}

contract PreSale2 is Pausable, SellTime, IPreSale2, ERC721{

    using Counters for Counters.Counter;

    mapping(address => bool) _buyer;

    uint public totalSellAmount = 2022;
    uint public permitSellAmount = 100;

    // mapping (uint => Counters.Counter) private _ticketSoldAmount; //Record how many ticket sold
    Counters.Counter private _nftCount;
    mapping (uint => string) private _ticketURI;
    mapping (uint => uint) private _ticketIndex;
    //Contracts
    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IBNBPrice public bnbPriceContract = IBNBPrice(0x52D3Ec80C702530D6f862Ce4bA1d20D9A7620315);

    uint private _priceForUSDT = 1000e18; //decimal = 18

    constructor() public ERC721("Marco", "Ticket") {
        _nftCount.increment();
    }

    function getPriceForUSDT() public view returns(uint){
        return _priceForUSDT;
    }

    function isBuyer(address user) external view returns(bool){
        return _buyer[user];
    }

    // function ticketSoldAmount() public view returns(uint){
    //    return _ticketSoldAmount;
    // }

    function ticketCount() public view returns(uint){
        return _nftCount.current();
    }

    function buyTicketByUsdt(
        
    ) override external whenNotPaused ticketSellTime{
        require(_nftCount.current() <= totalSellAmount, "Tickets sold out!");
        require(permitSellAmount <= 0, "You should buy ticket next time");
        require(msg.value >= getPriceForUSDT(),
            "The payment is not enough!"
        );
        usdtContract.safeTransfer(
            BitapeWallet,
            getPriceForUSDT().div(100).mul(15)
        );
        usdtContract.safeTransfer(
            MarcoWallet,
            getPriceForUSDT().div(100).mul(15)
        );
        usdtContract.safeTransfer(
            ArtistWallet,
            16e18
        );
        usdtContract.safeTransfer(
            wallet,
            getPriceForUSDT().div(100).mul(70).sub(16e18)
        );
        _buyTicket();
        _mintToken(msg.sender);
    }

//_buy

    function _buyTicket() private{
        _buyer[msg.sender] = true;
    }
//uri

    function ticketURI(uint tokenId) public view returns(string memory) {
        return _ticketURI[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory base = baseURI();

        // If there is no base URI, return the ticket URI.
        if (bytes(base).length == 0) {
            return ticketURI(tokenId);
        }
        // If both are set, concatenate the baseURI and ticketURI (via abi.encodePacked).
        if (bytes(ticketURI(tokenId)).length > 0) {
            return string(abi.encodePacked(base, ticketURI(tokenId)));
        }
        // If there is a baseURI but no ticketURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setBaseURI(string memory URI) external onlyOwner{
        _setBaseURI(URI);
    }

    function setTicketURI(uint tokenId, string memory URI) external onlyOwner{
        _ticketURI[tokenId] = URI;
    }
//_mint

    function _mintToken(address recipient) internal{
        require(_nftCount.current() <= totalSellAmount, "Tickets sold out!");
        uint tokenId = _nftCount.current();
        _mint(recipient, tokenId);
        _nftCount.increment();
        emit BuyTicket(msg.sender, now, tokenId);
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

    function setBnbPriceContract(IBNBPrice _bnbPriceContract) external onlyOwner{
        bnbPriceContract = _bnbPriceContract;
    }

    function setTotalSellAmount(uint amount) external onlyOwner{
        totalSellAmount = amount;
    }

    function setPermitSellAmount(uint amount) external onlyOwner{
        permitSellAmount = amount;
    }

    function setBitapeWallet(address _wallet) external onlyOwner{
        BitapeWallet = _wallet;
    }

    function setMarcoWallet(address _wallet) external onlyOwner{
        MarcoWallet = _wallet;
    }

    function setArtistWallet(address _wallet) external onlyOwner{
        ArtistWallet = _wallet;
    }

    function setClubWallet(address _wallet) external onlyOwner{
        ClubWallet = _wallet;
    }

    // function withdraw() external onlyOwner{
    //     payable(wallet).transfer(address(this).balance);
    //     usdtContract.transfer(wallet, usdtContract.balanceOf(address(this)));
    // }
}