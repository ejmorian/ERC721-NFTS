const {assert, expect} = require("chai");
const { ethers } = require("hardhat");

describe("BasicNFT", () => {

    let deployer, deployerContract, receiveNFTContract ;

    beforeEach(async () => {
        deployer = await ethers.getSigner();
        const BasicNFTFactory = await ethers.getContractFactory("BasicNFT", deployer);

        deployerContract = await BasicNFTFactory.deploy("Programmer", "PRO");
        await deployerContract.deployed();

        const MockReceiveNFT = await ethers.getContractFactory("receiveNFT", deployer);
        receiveNFTContract = await MockReceiveNFT.deploy();
        await receiveNFTContract.deployed();
    })

    describe("constructor", async () => {

        it("returns the name of the NFT collection", async () => {
            const name = await deployerContract.name();
            assert.equal(name, "Programmer");
        })

        it("returns the symbol of the NFT collection", async() => {
            const name = await deployerContract.symbol();
            assert.equal(name, "PRO");
        })

        describe("returns the supported interface as true", async () => {
            const interface = ["0x80ac58cd", "0x01ffc9a7", "0x5b5e139f"];

            it("returns ERC721 Interface ID to true", async () => {
                assert.equal(await deployerContract.supportsInterface(interface[0]), true);
            })

            it("returns ERC165 Interface ID to true", async () => {
                assert.equal(await deployerContract.supportsInterface(interface[1]), true);
            })


            it("returns ERC721METADATA Interface ID to true", async () => {
                assert.equal(await deployerContract.supportsInterface(interface[2]), true);
            })

        })

    })

    describe("mint", () => {
        it("deployer can mint and own new NFTs", async () => {
                const tx = await deployerContract.mint(deployer.address);
                await tx.wait(1)
                assert.equal(await deployerContract.ownerOf(1), deployer.address)
        })

        it("updates the balance", async () => {{
            const tx = await deployerContract.mint(deployer.address);
            await tx.wait(1)

            assert.equal((await deployerContract.balanceOf(deployer.address)).toString(), "1")
        }})

        it("reverts if msg.sender is not the deployer", async () => {
            const user = await ethers.getSigner(1)
            const userContract = await ethers.getContractAt("BasicNFT", deployerContract.address, user);

            await expect(userContract.mint(user.address)).to.be.revertedWith("Permission Denied.");
        })
    })

    describe("safeTransferFrom", () => {
        it("reverts if msg.sender does not have permission", async () => {

        })
    })
})