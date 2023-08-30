// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

/**
 * @title TokenOperationsTest Contract
 * @author Nika Khachiashvili
 * @dev Contract for testing token operation use cases
 */
contract TokenOperationsTest is ERC20PortfolioTest {
    /// @dev testing the deposit of token
    function testDepositFuzz(uint256 amount) public {
        portfolio.listToken(address(token));

        deal(address(token), address(this), amount);
        token.approve(address(portfolio), amount);
        portfolio.deposit(address(token), amount);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(portfolio)), amount);
    }

    /// @dev testing the transfer of token to another address
    function testTransferFuzz(uint256 amount) public {
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

    /// @dev testing the withdraw of token
    function testTransferAsWithdrawFuzz(uint256 amount) public {
        portfolio.listToken(address(token));

        deal(address(token), address(this), amount);
        token.approve(address(portfolio), amount);
        portfolio.deposit(address(token), amount);

        portfolio.transfer(address(token), address(this), amount);

        assertEq(token.balanceOf(address(this)), amount);
        assertEq(token.balanceOf(address(portfolio)), 0);
    }
}
