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

    function testUnlistOneOfTheTokens() public {
        for (uint256 i = 0; i < addresses1.length; i++) {
            portfolio.listToken(addresses1[i]);
        }
        portfolio.listToken(address(token));
        uint tokenId = portfolio.getSupportedTokenId(address(token));
        for (uint256 i = 0; i < addresses2.length; i++) {
            portfolio.listToken(addresses2[i]);
        }
        portfolio.unlistToken(address(token));
        assertEq(
            portfolio.getSupportedTokensCount(),
            addresses1.length + addresses2.length
        );
        assertEq(portfolio.getSupportedTokenId(address(token)), 0);
        assertEq(
            portfolio.supportedTokens(tokenId - 1),
            addresses2[addresses2.length - 1]
        );
    }
}
