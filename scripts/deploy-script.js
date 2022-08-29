const { ethers } = require("hardhat");

async function main() {
  const tokenContractFactory = await ethers.getContractFactory(
    "TestToken"
  );
  console.log("Deploying Contract ...");

  const tokenContract = await tokenContractFactory.deploy("Token", "TKN", "10000000000000000000000000");

  await tokenContract.deployed();
  console.log(`Contract deployed to : ${tokenContract.address}`);

  const totalSupply = await tokenContract.totalSupply();
  console.log(totalSupply)


  //////////////////// ICO ///////////////////////

  const tokenIcoFactory = await ethers.getContractFactory("TestTokenIco");
  console.log("Deploying ICO Contract .....")

  const tokenIco = await tokenIcoFactory.deploy(5, "0x6a2C3C4C7169d69A67ae2251c7D765Ac79A4967e", tokenContract.address, "10000000000000000");
  await tokenIco.deployed();

  console.log(`Contract deployed to : ${tokenIco.address}`);

  const buyToken = await tokenIco.buyTokens("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });