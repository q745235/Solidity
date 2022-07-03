import migrate from '../process/migrate';
import setUsdtContract from '../utils/setting/setUsdtContract';

migrate("0x55d398326f99059fF775485246999027B3197955").then(address => {
    console.log("Migrate ERC721DutchAuctionExample Finish");
})

