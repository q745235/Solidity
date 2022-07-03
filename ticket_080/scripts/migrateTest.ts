import migrateTest from '../process/migrateTest';
import setUsdtContract from '../utils/setting/setUsdtContract';

migrateTest("").then(address => {
    console.log("Migrate ERC721DutchAuctionExample Finish");
})

