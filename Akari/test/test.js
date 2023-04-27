const {ethers} = require("hardhat");
const {expect, assert} =require("chai");
describe("deploy", () => {
    beforeEach(async () => {
        const deployer = await ethers.getSigner();
        const contractFactory = await ethers.getContractFactory("Akari", deployer);
        console.log("Deploying Contract...")
        const akariContract = await contractFactory.deploy("Akari", "AKA");
        console.log("tx:",akariContract.deployTransaction.hash)
        await akariContract.deployed();
        console.log("contract deployed to:", akariContract.address);
    })
    it("checks gas", async () => {

        assert.equal(1,1)
    })
})