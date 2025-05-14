const hre = require("hardhat");

async function main() {
    let network = hre.network.name;
    let contractName = "SellerAgent";
    const contract = await hre.ethers.deployContract(contractName, []);
    await contract.waitForDeployment();
    console.log(`[${network}] Contract ${contractName} deployed to ${contract.target}!`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
