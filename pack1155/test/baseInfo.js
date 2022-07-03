const Trade = artifacts.require("Trade");

contract("Trade", async(accounts) => {
  let trade;

  before(async() => {
    trade = await Trade.deployed();
  })

  it("UsdtContract", async() => {
    const r = await trade.UsdtContract();
    console.log(r);
  });

  it("getTradableOrderCount", async() => {
    const r = await trade.getTradableOrderCount();
    console.log(r.toString());
  });

  it("getAllTradableOrder", async() => {
    const r = await trade.getAllTradableOrder();
    console.log(r);
  });


});