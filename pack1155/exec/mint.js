const Chest = artifacts.require("Chest");

module.exports = async function (done) {
  try {
        const chest = await Chest.deployed();
        await chest.setBaseURI("https://q745235/");
        await chest.setChestURI(1,"1.json");
        await chest.setOpen(1,true);
        await chest.setChestItem(1,2,4,35);
        await chest.setChestItem(1,101,4,35);
        await chest.setChestItem(1,102,4,10);
        await chest.setChestItem(1,103,4,10);
        await chest.setChestItem(1,201,4,5);
        await chest.setChestItem(1,202,5,2);
        await chest.setChestItem(1,203,5,2);
        await chest.setChestItem(1,301,5,1);
        await chest.setChestAmount(1,5);
        await chest.setItemCardContract('');
        let c = await chest.tokenURI(1);
        const r =await chest.mint(
          "",1,1
        )
        console.log(r);
        console.log(c);
        done()
  } catch (error) {
      console.log(error);
  }
};