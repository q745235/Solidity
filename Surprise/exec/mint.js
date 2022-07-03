const Surprise = artifacts.require("Surprise");

module.exports = async function (done) {
  try {
        const surprise = await Surprise.deployed();

        await surprise.setBaseURI("https://q745235/");
        await surprise.setSurpriseIndexURI(1,"1.json");
        await surprise.setSurpriseIndexURI(2,"2.json");
        // let r = await surprise.tokenURI(100);
        // console.log(r);
        // await surprise.setLuckyTime(1691484800);
        // console.log(await surprise.tokenURI(100));
        
        done()
  } catch (error) {
      console.log(error);
  }
};