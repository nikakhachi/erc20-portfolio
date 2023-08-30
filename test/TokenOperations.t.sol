// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

contract TokenOperationsTest is ERC20PortfolioTest {
    function testDeposit(uint256 amount) public {
        portfolio.listToken(address(token));

        deal(address(token), address(this), amount);
        token.approve(address(portfolio), amount);
        portfolio.deposit(address(token), amount);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(portfolio)), amount);
    }

    function testTransfer(uint256 amount) public {
        portfolio.listToken(address(token));

        deal(address(token), address(this), amount);
        token.approve(address(portfolio), amount);
        portfolio.deposit(address(token), amount);

        address recipient = address(1);

        portfolio.transfer(address(token), recipient, amount);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.balanceOf(address(portfolio)), 0);
    }
}