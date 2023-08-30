// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/access/Ownable.sol";
import "./UC.sol";
import "forge-std/console.sol";

contract ERC20Portfolio is Ownable {
    mapping(address => uint256) public supportedTokensToIds;
    address[] public supportedTokens;

    function listToken(address _token) external onlyOwner {
        require(supportedTokensToIds[_token] == 0, "Token already listed");
        supportedTokens.push(_token);
        /// @dev ids are 1-indexed, it avoids confusion with the default value 0
        supportedTokensToIds[_token] = supportedTokens.length;
    }

    function unlistToken(address _token) external onlyOwner {
        /// @dev If the malicious actor tries to unlist a token that's not listed, the id will be 0
        /// @dev And the transacton will revert with underflow error
        uint256 indexOfUnlistedToken = supportedTokensToIds[_token] - 1;
        if (supportedTokens.length != 1) {
            address lastToken = supportedTokens[supportedTokens.length - 1];
            supportedTokens[indexOfUnlistedToken] = lastToken;
            supportedTokensToIds[lastToken] = indexOfUnlistedToken;
        }
        supportedTokens.pop();
        supportedTokensToIds[_token] = 0;
        IERC20 token = IERC20(_token);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function deposit(address _token, uint256 _amount) external {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
    }

    function transfer(
        address _token,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        IERC20(_token).transfer(_to, _amount);
    }

    function showOriginalBalance(
        address _token
    ) external view returns (uint256) {
        return IERC20(_token).balanceOf(owner());
    }

    function showPortfolioBalance(
        address _token
    ) external view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function getSupportedTokenId(
        address _token
    ) external view returns (uint256) {
        return supportedTokensToIds[_token];
    }

    function getSupportedTokensCount() external view returns (uint256) {
        return supportedTokens.length;
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 length = supportedTokens.length;
        for (UC i = ZERO; i < uc(length); i = i + ONE) {
            IERC20 token = IERC20(supportedTokens[i.unwrap()]);
            token.transfer(msg.sender, token.balanceOf(address(this)));
        }
    }
}
