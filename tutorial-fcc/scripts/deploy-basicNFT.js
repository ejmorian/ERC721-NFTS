const { ethers, network } = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config")
const {verify} = require("./utils/verify");

const main = async () => {
    const deployer = await ethers.getSigner();
    const basicNFTFactory = await ethers.getContractFactory("BasicNFT", deployer)
    const basicNFT = await basicNFTFactory.deploy();
    console.log("deploying contract. tx:", basicNFT.deployTransaction.hash)
    developmentChains.includes(network.name) ? await basicNFT.deployTransaction.wait() : await basicNFT.deployTransaction.wait(6);
    console.log("succesfully deployed to:", basicNFT.address)

    if(!developmentChains.includes(network.name)){
        console.log("verifying contract..")
        await verify(basicNFT.address, [])
    }else{
        console.log("error: cannot verify contract in localchain...")
    }
}

main().then(() => process.exit(1)).catch((e)=> {
    console.error(e);
    process.exit(0)
} )