## How to Deploy and Test the Top Shot Contract in VSCode

The first step for using any smart contract is deploying it to the blockchain,
or emulator in our case. Do these commands in vscode.
See the [vscode extension instructions](https://docs.onflow.org/docs/visual-studio-code-extension)
to learn how to use it.

1.  Start the emulator with the `Run emulator` vscode command.
2.  Open the `NonFungibleToken.cdc` file from the [flow-nft repo](https://github.com/onflow/flow-nft/blob/master/contracts/NonFungibleToken.cdc) and the `NFTContract.cdc` file.
3.  In `NonFungibleToken.cdc`, click the `deploy contract to account`
    above the `Dummy` contract at the bottom of the file to deploy it.
    This also deploys the `NonFungibleToken` interface.
4.  In `NFTContract.cdc`, make sure it imports `NonFungibleToken` from
    the account you deployed it to.
5.  Click the `deploy contract to account` button that appears over the
    `NFTContract` contract declaration to deploy it to a new account.

The above steps deploy the contract code and it will initlialize the
contract storage variables.

After the contracts have been deployed, you can run the sample transactions
to interact with the contracts. The sample transactions are meant to be used
in an automated context, so they use transaction arguments and string template
fields. These make it easier for a program to use and interact with them.
If you are running these transactions manually in the Flow Playground or
vscode extension, you will need to remove the transaction arguments and
hard code the values that they are used for.

## NFTContract Addresses

`NFTContract.cdc`: This is the main NFTContract smart contract that defines
the core functionality of the NFT.

| Network | Contract Address     |
| ------- | -------------------- |
| Testnet | `0x91d21b0c6bbecfae` |


## Start Flow

### Creating the contract and minting a token

flow project start-emulator

flow project deploy

flow keys generate

## Command to setup an Admin Account

flow transactions send ./transactions/setupAdminAccount.cdc --signer emulator-account1

## Command to add an Admin Account

flow transactions send ./transactions/addAdminAccount.cdc 0x2261e8612a517c85 --signer my-testnet-account

## Command to create a Brand

flow transactions send ./transactions/createBrand.cdc "MY-BRAND" '{"1":"ONE"}' --signer emulator-account1

## Command to create a Schema

flow transactions send ./transactions/createSchema.cdc "MY-schema" --signer emulator-account1

## Command to create a Template

flow transactions send ./transactions/createTemplate.cdc 13 400 --signer emulator-account1

## Command to create a Template with static data

flow transactions send ./transactions/createTemplateStaticData.cdc 1 1 500 --signer emulator-account1

## Commands to setup at least two of accounts to recieve NFTs

flow transactions send ./transactions/setupAccount.cdc --signer emulator-account2

flow transactions send ./transactions/setupAccount.cdc --signer emulator-account3

## Command to Mint NFTs and deposit to given address

flow transactions send ./transactions/mintNFT.cdc 1 0x64779312e1907c86 --signer emulator-account1

flow transactions send ./transactions/mintNFT.cdc 1 0x9d6e7d65a5eb0811 --signer emulator-account1

## Command to transfer NFTs from one account to another

flow transactions send ./transactions/transferNFT.cdc 0x9d6e7d65a5eb0811 1 --signer emulator-account3


### All Scripts Commands

## Command to get all created Brands

flow scripts execute ./scripts/getAllBrands.cdc --network=testnet

## Command to get Brand by given ID

flow scripts execute ./scripts/getBrandById.cdc 1 --network=testnet

## Command to get all created Schemas

flow scripts execute ./scripts/getallSchema.cdc --network=testnet

## Command to get Schema by given ID

flow scripts execute ./scripts/getSchemaById.cdc 2 --network=testnet

## Command to get all created Templates

flow scripts execute ./scripts/getAllTemplates.cdc

## Command to get Template by given ID

flow scripts execute ./scripts/getTemplateById.cdc 1

## Command to get total minted NFTs

flow scripts execute ./scripts/getTotalSupply.cdc

## Command to get all minted NFTs for a given account

flow scripts execute ./scripts/getAllNFTIds.cdc 0x9d6e7d65a5eb0811

## Command to get NFT's Template data for given address

flow scripts execute ./scripts/getNFTTemplateData.cdc 0x64779312e1907c86 





