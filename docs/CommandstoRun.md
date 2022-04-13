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
| Testnet | `0x8f5c3c561b83eae3` |

## Instructions for creating Collection, Depositing NFT, Transfereing NFTs between Users

A common order of creating NFT would be
 - Create Collection on account with `transaction/createCollection`.
 - Create Collection on another account with `transaction/createCollection`.
 - Deposit an NFTs to accounts having a collection with `transactions/depositNFT` using Contract deployed Account.
 - Transfer NFTs among collection holders with `transaction/transferNFT`.
You can also see the scripts in `transactions/scripts` to see how information
can be read from the NFTContract. 

## NFTContract Events

- ` pub event ContractInitialized()`

  This event is emitted when the `NFTContract` will be initialized.

- `pub event Withdraw(id: UInt64, from: Address?)`
  This event is emitted when NFT will be withdrawn.

- `pub event Deposit(id: UInt64, to: Address?)`
  This event is emitted when NFT will be deposited.

## Start Flow

### Creating the contract and minting a token

flow project start-emulator

flow project deploy

flow keys generate

## Commands to create Collection on at least two of Accounts

flow transactions send transactions/createCollection.cdc --signer emulator-account1

flow transactions send transactions/createCollection.cdc --signer emulator-account2

## Command to Deposit NFTs on Accounts

flow transactions send transactions/depositNFT.cdc 0xfd43f9148d4b725d --signer emulator-account

## Command to Transfer NFT among Accounts

flow transactions send transactions/transferNFT.cdc 0xe03daebed8ca0615 1 --signer emulator-account1

## Commands to view total NFTs deposited on an Account

flow scripts execute scripts/getAccountNFT.cdc 0xfd43f9148d4b725d 1

## Command to view particular NFT data of particular Account

flow scripts execute scripts/getNFTData.cdc 0xfd43f9148d4b725d 1



