const hre = require("hardhat");

async function main() {
  const TokenFaucet = await hre.ethers.getContractFactory("TokenFaucet");
  const faucet = await TokenFaucet.deploy();

  await faucet.deployed();

  console.log("TokenFaucet deployed to:", faucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
