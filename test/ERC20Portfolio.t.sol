// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ERC20Portfolio.sol";
import "openzeppelin/token/ERC20/ERC20.sol";

contract ERC20PortfolioTest is Test {
    ERC20Portfolio public portfolio;
    ERC20 public token;

    address[7] addresses1 = [
        address(0),
        address(1),
        address(2),
        address(3),
        address(4),
        address(5),
        address(6)
    ];
    address[3] addresses2 = [address(7), address(8), address(9)];

    function setUp() public {
        portfolio = new ERC20Portfolio();
        token = new ERC20("Test", "TEST");
    }

    /// @dev testing initial values on deployment
    function testInitialValues() public {
        assertEq(portfolio.owner(), address(this));
        assertEq(portfolio.getSupportedTokensCount(), 0);
    }
}
