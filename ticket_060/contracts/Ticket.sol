// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SellTime is Ownable{

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public OneWallet;
    address public TwoWallet;
    address public ThreeWallet;
    uint public ticketSellStartTime = 1663673600;
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

interface ITicket {
    event BuyTicket(address buyer, uint time, uint tokenId);
    function buyTicketByUsdt() external;
}

contract Ticket is Pausable, SellTime, ITicket, ERC721{

    using Counters for Counters.Counter;
    using Strings for string;
    mapping(address => bool) _buyer;

    uint public totalSellAmount = 2022;
    uint public permitSellAmount = 100;

    Counters.Counter private _nftCount;
    mapping (uint => string) private _ticketURI;
    mapping (uint => uint) private _ticketIndex;

    //Contracts

    IERC20 public usdtContract = IERC20(0x55d398326f99059fF775485246999027B3197955);

    uint private _priceForUSDT = 1000e18; //decimal = 18

    constructor() public ERC721("Two", "Ticket") {
    }

    function getPriceForUSDT() public view returns(uint){
        return _priceForUSDT;
    }

    function isBuyer(address user) external view returns(bool){
        return _buyer[user];
    }


    function ticketCount() public view returns(uint){
        return _nftCount.current();
    }

    function buyTicketByUsdt(
        
    ) override external whenNotPaused ticketSellTime{
        require(_nftCount.current() < totalSellAmount, "Tickets sold out!");
        require(permitSellAmount > 0, "You should buy ticket next time");
        
        usdtContract.safeTransferFrom(
            msg.sender,
            OneWallet,
            getPriceForUSDT().div(100).mul(15)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            TwoWallet,
            getPriceForUSDT().div(100).mul(15)
        );
        usdtContract.safeTransferFrom(
            msg.sender,
            ThreeWallet,
            getPriceForUSDT().div(100).mul(70)
        );
        permitSellAmount = permitSellAmount.sub(1);
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

    function mint(address recipient) external onlyOwner{
        _mintToken(recipient);
    }

    function _mintToken(address recipient) internal{
        require(_nftCount.current() < totalSellAmount, "Tickets sold out!");
        _nftCount.increment();
        uint tokenId = _nftCount.current();
        _mint(recipient, tokenId);
        string memory i = uintToString(tokenId);
        _ticketURI[tokenId] = string(abi.encodePacked( string(i), ".json"));
        emit BuyTicket(recipient, now, tokenId);
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

    function setTotalSellAmount(uint amount) external onlyOwner{
        totalSellAmount = amount;
    }

    function setPermitSellAmount(uint amount) external onlyOwner{
        permitSellAmount = amount;
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

    function withdraw() external onlyOwner{
        payable(OneWallet).transfer(address(this).balance);
        usdtContract.transfer(OneWallet, usdtContract.balanceOf(address(this)));
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