// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/access/Ownable.sol";
import "./UC.sol";
import "forge-std/console.sol";

contract ERC20Portfolio is Ownable {
    error InvalidToken();

    /// @dev Used when requesting balances of all tokens
    struct TokenBalance {
        address token;
        uint256 balance;
    }

    mapping(address => uint256) public supportedTokensToIds;
    address[] public supportedTokens;

    function listToken(address _token) external onlyOwner {
        if (supportedTokensToIds[_token] != 0) revert InvalidToken();

        supportedTokens.push(_token);

        /// @dev ids are 1-indexed, it avoids confusion with the default value 0 also it prevents
        /// @dev malicious actors from unlisting the nonexisting token (explanation in unlistToken())
        supportedTokensToIds[_token] = supportedTokens.length;

        /// @dev With this, the fucntion also makes sure that only ERC20 addresses are listed
        /// @dev Without it, if the owner incorrectly lists non-erc20, the unlisting transaction
        /// @dev  will revert because it uses .transfer() method
        IERC20 token = IERC20(_token);
        token.transferFrom(
            msg.sender,
            address(this),
            token.allowance(msg.sender, address(this))
        );
    }

    function unlistToken(address _token) external onlyOwner {
        if (supportedTokens.length != 1) {
            /// @dev If the malicious actor tries to unlist a token that's not listed, the id will be 0
            /// @dev And the transacton will revert with underflow error
            uint256 indexOfUnlistedToken = supportedTokensToIds[_token] - 1;
            address lastToken = supportedTokens[supportedTokens.length - 1];
            supportedTokens[indexOfUnlistedToken] = lastToken;
            supportedTokensToIds[lastToken] = indexOfUnlistedToken;
        }

        supportedTokens.pop();
        supportedTokensToIds[_token] = 0;

        IERC20 token = IERC20(_token);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    /// @notice Deposit any amount of any tokens into the contract
    /// @dev There's no check because to save the gas. If owner deposits tokens that are not listed, they can use transfer() to get them back
    /// @dev There's no onlyOwner check because the owner doesn't lose anything if someone else deposits tokens
    /// @param _token The address of the token to deposit
    /// @param _amount The amount of tokens to deposit
    function deposit(address _token, uint256 _amount) external {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
    }

    /// @notice Transfer any amount of any tokens from the contract to any address
    /// @notice Can be used to withdraw the funds by simply specifying the owner address
    /// @param _token The address of the token to transfer
    /// @param _to The address to transfer the tokens to
    /// @param _amount The amount of tokens to transfer
    function transfer(
        address _token,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        IERC20(_token).transfer(_to, _amount);
    }

    function getOwnersBalance(address _token) external view returns (uint256) {
        return IERC20(_token).balanceOf(owner());
    }

    function getPortfolioBalance(
        address _token
    ) external view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    /// @notice Get owner balances of all tokens using the pagination
    /// @dev If user provides pageSize that is greater than the number of tokens, the function will revert
    /// @dev I didn't want to put in extra code for that, so user will have to calculate the correct arguments
    /// @param page The page number to start from
    /// @param pageSize The number of tokens to return
    /// @return TokenBalance[] An array of TokenBalance structs
    function getOwnersBalances(
        uint page,
        uint pageSize
    ) external view returns (TokenBalance[] memory) {
        TokenBalance[] memory tokenBalances = new TokenBalance[](pageSize);

        UC index = ZERO;
        /// @dev Starting with page 0
        for (
            UC i = uc(page * pageSize);
            i < uc((page + 1) * pageSize);
            i = i + ONE
        ) {
            uint256 id = i.unwrap();
            address tokenAddress = supportedTokens[id];
            IERC20 token = IERC20(tokenAddress);
            tokenBalances[index.unwrap()] = TokenBalance({
                token: tokenAddress,
                balance: token.balanceOf(owner())
            });
            index = index + ONE;
        }
        return tokenBalances;
    }

    /// @notice Get portfolio balances of all tokens using the pagination
    /// @dev If user provides pageSize that is greater than the number of tokens, the function will revert
    /// @dev I didn't want to put in extra code for that, so user will have to calculate the correct arguments
    /// @param page The page number to start from
    /// @param pageSize The number of tokens to return
    /// @return TokenBalance[] An array of TokenBalance structs
    function getPortfolioBalances(
        uint page,
        uint pageSize
    ) external view returns (TokenBalance[] memory) {
        TokenBalance[] memory tokenBalances = new TokenBalance[](pageSize);

        UC index = ZERO;
        /// @dev Starting with page 0
        for (
            UC i = uc(page * pageSize);
            i < uc((page + 1) * pageSize);
            i = i + ONE
        ) {
            uint256 id = i.unwrap();
            address tokenAddress = supportedTokens[id];
            IERC20 token = IERC20(tokenAddress);
            tokenBalances[index.unwrap()] = TokenBalance({
                token: tokenAddress,
                balance: token.balanceOf(address(this))
            });
            index = index + ONE;
        }
        return tokenBalances;
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
