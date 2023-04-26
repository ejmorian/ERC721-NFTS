const {ethers} = require("hardhat");

const main = async () => {

    const deployer = await ethers.getSigner();
    const contractFactory = await ethers.getContractFactory("Akari", deployer);
    console.log("Deploying Contract...")
    const akariContract = await contractFactory.deploy("Akari", "AKA");
    console.log("tx:",akariContract.deployTransaction.hash)
    await akariContract.deployed();
    console.log("contract deployed to:", akariContract.address);
}

main().then(() => process.exit(1)).catch((e) =>{
  console.error(e);
  process.exit(0)

} )