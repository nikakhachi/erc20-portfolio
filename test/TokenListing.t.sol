// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

contract TokenListingTest is ERC20PortfolioTest {
    /// @dev testing the listing of token
    function testListTokenFuzz(address _token) public {
        portfolio.listToken(_token);
        assertEq(portfolio.getSupportedTokensCount(), 1);
        assertEq(portfolio.supportedTokens(0), _token);
        assertEq(portfolio.getSupportedTokenId(_token), 1);
    }

    /// @dev testing the listing of token
    function testListExistingTokenFuzz(address _token) public {
        portfolio.listToken(_token);
        vm.expectRevert();
        portfolio.listToken(_token);
    }
}
