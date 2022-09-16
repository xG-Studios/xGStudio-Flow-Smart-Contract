## Technical Summary and Code Documentation

## Instructions for Create Brand, Create Schema, Create Template, Mint NFT

Right Now, only the contract owner have the admin access. Therefore, only contract owner can create Brand, Schema, Template and mint NFTs.

A common order of creating NFT would be

- Create new Brand with `transactions/createBrand.cdc` using Admin Account.
- Create new Schema with `transactions/createSchema.cdc` using Admin Account.
- Create new Template with `transactions/createTemplate.cdc` using Admin Account.
- Create NFT Receiver with `transactions/setupAccount.cdc`.
- Mint NFT with `transactions/mintNFT.cdc`.

You can also see the scripts in `scripts` to see how information
can be read from the XGStudio smart-contract.

### XGStudio Events

- Contract Initialized ->
  `pub event ContractInitialized()`
  This event is emitted when the `XGStudio` will be initialized.

- Event for Brand ->
  `pub event BrandCreated(brandId: UInt64, brandName: String, author: Address, data: {String:String})`
  Emitted when a new Brand will be created and added to the smart Contract.

- Event for Brand Updation ->
  `pub event BrandUpdated(brandId: UInt64, brandName: String, author: Address, data: {String:String}) `
  Emitted when a Brand will be update

- Event for Schema ->
  `pub event SchemaCreated(schemaId: UInt64, schemaName: String, author: Address)`
  Emitted when a new Schema will be created

- Event for Template ->
  `pub event TemplateCreated(templateId: UInt64, brandId: UInt64, schemaId: UInt64, maxSupply: UInt64)`
  Emitted when a new Template will be created

- Event for Template Mint ->
  `pub event NFTMinted(nftId: UInt64, templateId: UInt64, mintNumber: UInt64)`
  Emitted when a Template will be Minted and save as NFT

## XGStudio Addresses

`XGStudio.cdc`: This is the main XGStudio smart contract that defines the core functionality of the NFT.

| Network | Contract Address     |
| ------- | -------------------- |
| Testnet | `0xd9575c84a88eada0` |
| Mainnet | `0xc357c8d061353f5f` |

### Deployment Contract on Emulator

- Start the emulator with predeployed standard contracts: `flow emulator --contracts`
- Run `flow project deploy --network emulator`
  - All contracts are deployed to the emulator.

After the contracts have been deployed, you can run the sample transactions
to interact with the contracts. The sample transactions are meant to be used
in an automated context, so they use transaction arguments and string template
fields. These make it easier for a program to use and interact with them.
If you are running these transactions manually in the Flow Playground or
vscode extension, you will need to remove the transaction arguments and
hard code the values that they are used for.

### Deployment to testnet and mainnet

- Create a `.env` file and add your testnet and/or mainnet private keys, see `.env.example`
  - Alternatively add the env variables in your command, eg. `MAINNET_PRIVATE_KEY=123 flow deploy…"`
- Run the deployment command:
  - Testnet `flow deploy --update -f flow.json -f flow.testnet.json --network testnet`
  - Mainnet `flow deploy --update -f flow.json -f flow.mainnet.json --network mainnet`

The current deployment addresses (see above) are pre-filled in the deployment configs at `flow.(testnet|mainnet).json`.
If you want to deploy to another account you need to change them as well.
