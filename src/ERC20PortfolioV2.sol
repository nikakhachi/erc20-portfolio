// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ERC20Portfolio.sol";

/**
 * @title ERC20PortfolioV2 Contract
 * @author Nika Khachiashvili
 * @dev JUST FOR DEMOSTRATION PURPOSES
 */
contract ERC20PortfolioV2 is ERC20Portfolio {
    function version() external pure returns (string memory) {
        return "v2";
    }
}
