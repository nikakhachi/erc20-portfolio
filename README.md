# ERC20 Token Portfolio.

This project implements an upgradeable (UUPS Proxy pattern) ERC20Portfolio smart contract, where the owner of the contract is able to add, remove, show list of tokens with their balances, to transfer tokens for the user from the portfolio smart contract and to withdraw all the funds in case of emergency

The development tool used is the Foundry where the contracts and the tests are written, and then there's Hardhat integrated which is used for writing the deployment and upgrade scripts.

## Table of Contents

- [Features](#features)
- [Testing](#testing)
- [Deploying](#deploying)

## Features

### EventFactory Contract

- **_listToken_** - Owner can list the token in portfolio by calling this function. The argument passed should be the address of that token. If the address isn't ERC20 token the transaction will revert because at the end of the function, smart contracts tries to transfer all the allowance from that address to the portfolio. It's done for safety reasons so that invalid address isn't added and if the allowance is 0, it's okay

- **_unlistToken_** - Owner can unlist the token from portfolio by calling this function. The argument passed should be the address of that token. After unlisting, all the funds of that token that were in the portfolio, will be transfered to owner

- **_deposit_** - Function for depositing any amount of any token into the contract. Anyone can call this function, because owner isn't losing anything when someone deposits some token in the contract. Can only deposit listed contracts. Sure if owner mistakenly transfers wrong tokens to portfolio they can withdraw them by calling _transfer_ function but if this goes unnoticed, at the time of emergencyWithdraw(), those tokens will not get withdrawn and will be a panic situation

- **_transfer_** - Owner can transfer token funds by calling this function. It can be also used to withdraw the funds or send it to someone else.

- **_getOwnersBalance_** - Get the owners balance of the specific token

- **_getPortfolioBalance_** - Get the portfolios balance of the specific token

- **_getOwnersBalances_** - Get owner balances of all tokens using the pagination. The function does the iteration over the array so pagination is implemented to avoid unnecessary reverts.

- **_getPortfolioBalances_** - Get portfolio balances of all tokens using the pagination. The function does the iteration over the array so pagination is implemented to avoid unnecessary reverts.

- **_getSupportedTokenId_** - Get ID of the supported token (the place in array for the token will be ID from the mapping - 1. Explained in details in code)

- **_getSupportedTokensCount_** - Get the total number of supported tokens

- **_emergencyWithdraw_** - Owner can call this function to withdraw EVERY fund of EVERY token that's listed in the portfolio.

## Testing

Tests are written to cover as many scenarios as possible, but still, it's not enough for production. This should never happen in production-ready code!

To run the tests, you will have to do the following

1. Clone this repository to your local machine.
2. Run `forge install`.
3. Run `forge build`.
4. Run `forge test`.

OR, you can just run `forge test`, which will automatically install dependencies and compile the contracts.

## Deploying

To deploy the contract, you will have to do the following

1. Clone this repository to your local machine.
2. Run `forge install && npm install`.
3. Create the `.env` file based on the `.env.example`.
4. Modify network options in `hardhat.config.ts`.
5. Deploy the smart contract with ` npx hardhat run script/deploy.ts --network {network name}`

If you would like to deploy it locally, make sure to run `npx hardhat node` before the 3rd step, and deploy the smart contract with `localhost` as the "network name"
