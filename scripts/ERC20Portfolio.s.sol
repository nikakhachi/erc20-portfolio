// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ERC20Portfolio.sol";

/**
 * @title ERC20PortfolioScript Contract
 * @author Nika Khachiashvili
 * @dev Script for deploying NON-UPGRADEABLE ERC20Portfolio contract
 * @dev I have this file only for DEMONSTRATION PURPOSES, for deploying
 * @dev Upgradeable contracts, use hardhat scripts
 */
contract ERC20PortfolioScript is Script {
    function setUp() public {}

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new ERC20Portfolio();

        vm.stopBroadcast();
    }
}
