// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./exmples/ERC721/ERC721ApproveLock.sol";
import "./modules/PurchaseTime.sol";
import "./modules/Withdraw.sol";
import "./modules/Fee.sol";
import "./modules/WhiteList.sol";
import "./libraries/StatisticsLimited.sol";

contract Ticket is 
    ERC721ApproveLock,
    PurchaseTime,
    Fee,
    Withdraw
{

    using StatisticsLimited for StatisticsLimited.Data;

    StatisticsLimited.Data internal statistics;

    string constant ticket = "ticket";

    uint public ticketPrice = 100e18;
     
    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721ApproveLock(name, symbol, baseTokenURI) {
        _setLimited(ticket, 888);
    }

    event Buy(
        address buyer,
        uint tokenId,
        uint time
    );

    function getStatisticsAmount(
        string memory itemName
    ) external view returns(uint){
        return statistics.getAmount(itemName);
    }

    function getStatisticsLimited(
        string memory itemName
    ) external view returns(uint){
        return statistics.getLimited(itemName);
    }

    function getStatisticsItem() external view returns(string[] memory){
        return statistics.getItems();
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) external onlyRole(MANAGER_ROLE){
        _setTokenURI(tokenId, _tokenURI);
    }

    function setApprovalFor(uint256 tokenId, string memory _tokenURI) external onlyRole(MANAGER_ROLE){
        _setTokenURI(tokenId, _tokenURI);
    }

    function buy() external checkInTime() whenNotPaused(){
        statistics.addAmount(ticket, 1);
        _BuyerPayUsdt(ticketPrice);
        uint tokenId = _mintToken(_msgSender(), "ticket.json");
        emit Buy(_msgSender(), tokenId, block.timestamp);
    }

    function batchBuy(uint amount) external checkInTime() whenNotPaused(){
        statistics.addAmount(ticket, amount);
        _BuyerPayUsdt(ticketPrice * amount);
        for(uint i = 0; i < amount; i++){
            uint tokenId = _mintToken(_msgSender(), "ticket.json");
            emit Buy(_msgSender(), tokenId, block.timestamp);
        }
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721ApproveLock, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _setAmount(
        string memory item, uint amount
    ) private{
        statistics.setAmount(item, amount);
    }

    function _setLimited(
        string memory item, uint limited
    ) private{
        statistics.setLimited(item, limited);
    }

    function setAmounts(string memory item, uint amount) external onlyRole(MANAGER_ROLE){
        _setAmount(item, amount);
    }

    function setLimiteds(string memory item, uint limited) external onlyRole(MANAGER_ROLE){
        _setLimited(item, limited);
    }

    function setTicketPrice(uint price) external onlyRole(MANAGER_ROLE){
        ticketPrice = price;
    }
}