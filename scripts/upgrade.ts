import { upgrades, ethers } from "hardhat";

const PROXY = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

const main = async () => {
  const PortfolioFactoryV2 = await ethers.getContractFactory("ERC20PortfolioV2");
  const portfolioV2 = await upgrades.upgradeProxy(PROXY, PortfolioFactoryV2);

  await portfolioV2.waitForDeployment();

  console.log(`Implementation ${await portfolioV2.version()} has been Deployed`);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
