const {ethers, network} = require("hardhat");
const {verify} = require("../utils/verify")

const main = async () => {

  

    const deployer = await ethers.getSigner();
    const contractFactory = await ethers.getContractFactory("Akari", deployer);
    console.log("Deploying Contract...")
    const akariContract = await contractFactory.deploy("Akari", "AKA");
    console.log("tx:",akariContract.deployTransaction.hash)
    console.log("waiting for confirmations...")
    await akariContract.deployTransaction.wait(6)
    console.log("contract deployed to:", akariContract.address);

    if(network.name == "polygon_mumbai"){
      await verify(akariContract.address, ["Akari", "AKA"]);
    }else{
      console.log("not in polygon network...")
    }

}

main().then(() => process.exit(1)).catch((e) =>{
  console.error(e);
  process.exit(0)

} )