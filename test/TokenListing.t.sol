// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

/**
 * @title TokenListingTest Contract
 * @author Nika Khachiashvili
 * @dev Contract for testing token listing functionality
 */
contract TokenListingTest is ERC20PortfolioTest {
    /// @dev testing the listing of token on empty portfolio
    function testListTokenOnEmptyPortfolioFuzz(address _token) public {
        portfolio.listToken(_token);
        assertEq(portfolio.getSupportedTokensCount(), 1);
        assertEq(portfolio.supportedTokens(0), _token);
        assertEq(portfolio.getSupportedTokenId(_token), 1);
    }

    /// @dev testing the listing of token on empty portfolio
    function testListTokenOnExistingPortfolioFuzz(uint8 amount) public {
        vm.assume(amount < 20); /// @dev Just to make tests faster

        for (uint8 i = 0; i < amount; i++) {
            portfolio.listToken(address(new ERC20("Test", "TEST")));
        }

        portfolio.listToken(address(token));

        assertEq(portfolio.getSupportedTokensCount(), amount + 1);
        assertEq(portfolio.supportedTokens(amount), address(token));
        assertEq(portfolio.getSupportedTokenId(address(token)), amount + 1);
    }

    /// @dev testing the listing of token
    function testListExistingTokenFuzz(address _token) public {
        portfolio.listToken(_token);
        vm.expectRevert(ERC20Portfolio.InvalidToken.selector);
        portfolio.listToken(_token);
    }
}
