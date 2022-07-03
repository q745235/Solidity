import { expect } from "chai";
import { ethers } from "hardhat";
import deploy from '../../utils/deploy';
import {TestPermission} from '../../typechain';
import {SignerWithAddress} from '@nomiclabs/hardhat-ethers/signers';

describe("Permission", () => {
    let testPermission: TestPermission;
    let owner: SignerWithAddress;
    let manager: SignerWithAddress;
    let minter: SignerWithAddress;
    let guest: SignerWithAddress;
    const MANAGER_ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER_ROLE"))
    
    before(async() => {
        testPermission = <TestPermission>await deploy("TestPermission");
        [owner, manager, minter, guest] = await ethers.getSigners();
    });

    it('owner mint test', async() => {
        await testPermission.mint();
    });

    it('manager grant mint before is manager', async() => {
        let getError = false;
        try {
            await testPermission.connect(manager.address).grantMinter(minter.address);
        } catch (error) {
            getError = true;
        }
        expect(getError).to.be.true;//It must be error
    });

    it('manager be a manager', async() => {
        await testPermission.grantManager(manager.address);
    });

    it('minter mint test before grant', async() => {
        let getError = false;
        try {
            await testPermission.connect(minter).mint();
        } catch (error) {
            getError = true;
        }
        expect(getError).to.be.true;//It must be error
    });

    it('manager grant mint after is manager', async() => {
        await testPermission.connect(manager).grantMinter(minter.address);
    });

    it('minter mint test after grant', async() => {
        await testPermission.connect(minter).mint();
    });
})