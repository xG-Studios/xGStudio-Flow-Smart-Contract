
## Technical Summary and Code Documentation

## Instructions for creating Collection, Depositing NFT, Transfereing NFTs between Users

A common order of creating NFT would be
 - Create Collection on account with `transaction/createCollection`.
 - Create Collection on another account with `transaction/createCollection`.
 - Deposit an NFTs to accounts having a collection with `transactions/depositNFT` using Contract deployed Account.
 - Transfer NFTs among collection holders with `transaction/transferNFT`.
You can also see the scripts in `transactions/scripts` to see how information
can be read from the NFTContract. 


### NFTContract Events

 - Contract Initialized ->
`pub event ContractInitialized()` 
This event is emitted when the `NFTContract` will be initialized.

- Event for Withdraw NFT ->
`pub event Withdraw(id: UInt64, from: Address?)`
This event is emitted when NFT will be withdrawn.

- Event for Deposit NFT ->
`pub event Deposit(id: UInt64, to: Address?)`
This event is emitted when NFT will be deposited.


## NFTContract Addresses

`NFTContract.cdc`: This is the main NFTContract smart contract that defines
the core functionality of the NFT.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | `0x8f5c3c561b83eae3` |


## NFTContract Overview Technical

Each NFTContract represent a standard to create an NFT. We inherited NonFungibleToken to conform our standard with the existent NFT standard.

## Instructions for Creating a Collection 

Collections can be created on any account 


## Instructions to Deposit NFTs

NFTs can be only minted by Admin which is Contract Account for now
To Deposit NFTs to accounts having collections, we have to give the following fields:

- recipient: Address

Signer would be Contract Account for now


## Instructions to Transfer NFTs

To Transfer NFTs within the accounts having Collection, we have to give the following fields:

- recipient: Address
- id: UInt64


### Deployment Contract on Emulator

-  Run `flow project deploy --network emulator`
    - All contracts are deployed to the emulator.

After the contracts have been deployed, you can run the sample transactions
to interact with the contracts. The sample transactions are meant to be used
in an automated context, so they use transaction arguments and string template
fields. These make it easier for a program to use and interact with them.