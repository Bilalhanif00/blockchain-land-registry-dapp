const { ethers } = require("hardhat");

async function main() {
    const LandRegistry = await ethers.getContractFactory("LandRegistry");
    const landRegistry = await LandRegistry.deploy();

    console.log("✅ Waiting for deployment...");
    await landRegistry.waitForDeployment(); // ✅ Fixed: Use waitForDeployment() instead of deployed()

    console.log("✅ Contract deployed to:", await landRegistry.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error("❌ Deployment failed:", error);
        process.exit(1);
    });
