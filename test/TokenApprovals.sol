// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

/**
 * @title TokenApprovalsTest Contract
 * @author Nika Khachiashvili
 * @dev Contract for testing token approval operations
 */
contract TokenApprovalsTest is ERC20PortfolioTest {
    function testApproveTokenFuzz(address _spender, uint256 _amount) public {
        portfolio.listToken(address(token));
        portfolio.approve(address(token), _spender, _amount);
        assertEq(portfolio.approvals(_spender, address(token)), _amount);
    }

    function testRevokeTokenFuzz(address _spender, uint256 _amount) public {
        portfolio.listToken(address(token));
        portfolio.approve(address(token), _spender, _amount);
        portfolio.revoke(address(token), _spender);
        assertEq(portfolio.approvals(_spender, address(token)), 0);
    }

    function testRevokeAllTokenFuzz(address _spender, uint256 _amount) public {
        portfolio.listToken(address(token));
        ERC20 newToken = new ERC20("Test", "TEST");
        portfolio.listToken(address(newToken));

        portfolio.approve(address(token), _spender, _amount);
        portfolio.approve(address(newToken), _spender, _amount);

        portfolio.revokeAll(_spender);

        assertEq(portfolio.approvals(_spender, address(token)), 0);
        assertEq(portfolio.approvals(_spender, address(newToken)), 0);
    }

    function testTransferByApprovedSpender(uint256 _amount) public {
        address _spender = address(1);

        portfolio.listToken(address(token));

        deal(address(token), address(this), _amount);
        token.approve(address(portfolio), _amount);
        portfolio.deposit(address(token), _amount);

        portfolio.approve(address(token), _spender, _amount);

        vm.prank(_spender);
        portfolio.transfer(address(token), _spender, _amount);

        assertEq(token.balanceOf(_spender), _amount);
    }

    function testTransferByUnapprovedSpender(uint256 _amount) public {
        vm.assume(_amount > 0);
        address _spender = address(1);

        portfolio.listToken(address(token));

        deal(address(token), address(this), _amount);
        token.approve(address(portfolio), _amount);
        portfolio.deposit(address(token), _amount);

        vm.prank(_spender);
        vm.expectRevert(ERC20Portfolio.NotApproved.selector);
        portfolio.transfer(address(token), _spender, _amount);
    }
}
