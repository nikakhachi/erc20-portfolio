// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

contract TokenUnlistingTest is ERC20PortfolioTest {
    function testUnlistTheOnlyTokenWithZeroBalance() public {
        portfolio.listToken(address(token));
        portfolio.unlistToken(address(token));
        assertEq(portfolio.getSupportedTokensCount(), 0);
        assertEq(portfolio.getSupportedTokenId(address(token)), 0);
    }

    function testUnlistTheOnlyTokenWithBalanceFuzz(uint256 amount) public {
        deal(address(token), address(this), amount);

        portfolio.listToken(address(token));

        token.approve(address(portfolio), amount);
        portfolio.deposit(address(token), amount);

        portfolio.unlistToken(address(token));

        assertEq(portfolio.getSupportedTokensCount(), 0);
        assertEq(portfolio.getSupportedTokenId(address(token)), 0);
        assertEq(token.balanceOf(address(this)), amount);
        assertEq(token.balanceOf(address(portfolio)), 0);
    }

    function testUnlistOneOfTheTokens(uint8 amount1, uint8 amount2) public {
        /// @dev Just to make tests faster
        vm.assume(amount1 < 20 && amount1 > 0);
        vm.assume(amount2 < 20 && amount2 > 0);

        for (uint256 i = 0; i < amount1; i++) {
            portfolio.listToken(address(new ERC20("Test", "TEST")));
        }

        /// @dev listing our target token
        portfolio.listToken(address(token));
        uint tokenId = portfolio.getSupportedTokenId(address(token));

        address lastTokenAddress;
        for (uint256 i = 0; i < amount2; i++) {
            address token = address(new ERC20("Test", "TEST"));
            portfolio.listToken(token);
            lastTokenAddress = token;
        }

        portfolio.unlistToken(address(token));

        assertEq(portfolio.getSupportedTokensCount(), amount1 + amount2);
        assertEq(portfolio.getSupportedTokenId(address(token)), 0);
        assertEq(portfolio.supportedTokens(tokenId - 1), lastTokenAddress);
    }

    function testUnlistInvalidTokenFuzz(address token) public {
        vm.expectRevert();
        portfolio.unlistToken(address(token));
    }
}
