import { expect } from "chai";
import { ethers, network } from "hardhat";
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers';
import {ERC721Example} from '../typechain';

describe("hashId", () => {
    let erc721Contract: ERC721Example;
    let owner: SignerWithAddress;

    before(async() => {
        [owner] = await ethers.getSigners();
    })

    it("create erc721 contract", async() => {
        const Erc721Ins = await ethers.getContractFactory("ERC721Example");
        erc721Contract = <ERC721Example>await Erc721Ins.deploy(
            "Example ERC721",
            "EXAMPLE",
            "https://q745235/"
        )
    })

    it("mint erc721 token", async() => {
        await erc721Contract.connect(owner).mint(
            owner.address,
        )
    })

    it("get erc721 token id", async() => {
        const tokenId = await erc721Contract.connect(owner).tokenOfOwnerByIndex(
            owner.address,
            0
        )
        console.log(tokenId);
        expect(tokenId).to.equal(1);
        await erc721Contract.tokenURI(tokenId)
    })
})