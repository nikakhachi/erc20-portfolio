// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.t.sol";

contract EmergencyWithdrawTest is ERC20PortfolioTest {
    function testEmergencyWithdraw(uint8 amount) public {
        vm.assume(amount < 10); /// @dev Just to make test faster

        address[] memory tokens = new address[](amount);

        for (uint8 i = 0; i < amount; i++) {
            address tokenAddress = address(new ERC20("Test", "TEST"));
            tokens[i] = tokenAddress;
            portfolio.listToken(tokenAddress);
            deal(tokenAddress, address(this), i);
            ERC20(tokenAddress).transfer(address(portfolio), i);
        }

        portfolio.emergencyWithdraw();

        for (uint8 i = 0; i < amount; i++) {
            ERC20 token = ERC20(tokens[i]);
            assertEq(token.balanceOf(address(this)), i);
            assertEq(token.balanceOf(address(portfolio)), 0);
        }
    }
}
