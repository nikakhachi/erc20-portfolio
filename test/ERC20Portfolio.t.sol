// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ERC20Portfolio.sol";
import "openzeppelin/token/ERC20/ERC20.sol";

/**
 * @title ERC20PortfolioTest Contract
 * @author Nika Khachiashvili
 * @dev Main test contract for testing the Portfolio
 */
contract ERC20PortfolioTest is Test {
    /// @dev Portfolio contract
    ERC20Portfolio public portfolio;

    /// @dev Random Token for testing purposes
    ERC20 public token;

    /// @dev Setting up the testing environment
    function setUp() public {
        portfolio = new ERC20Portfolio();
        portfolio.initialize();
        token = new ERC20("Test", "TEST");
    }

    /// @dev testing initial values on deployment
    function testInitialValues() public {
        assertEq(portfolio.owner(), address(this));
        assertEq(portfolio.getSupportedTokensCount(), 0);
    }
}
