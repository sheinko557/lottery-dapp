import hardhat from "hardhat";

async function main() {
  // Get the contract factory
  const Lottery = await hardhat.ethers.getContractFactory("Lottery");

  // Deploy the contract
  const lottery = await Lottery.deploy();

  console.log("Lottery contract deployed to:", lottery.address);
}

// Execute the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
