import { upgrades, ethers } from "hardhat";

const main = async () => {
  const PortfolioFactory = await ethers.getContractFactory("ERC20Portfolio");
  const portfolio = await upgrades.deployProxy(PortfolioFactory, [], { kind: "uups" });

  await portfolio.waitForDeployment();

  const portfolioAddress = await portfolio.getAddress();

  console.log(`Portfolio Proxy Deployed on Address: ${portfolioAddress}`);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
