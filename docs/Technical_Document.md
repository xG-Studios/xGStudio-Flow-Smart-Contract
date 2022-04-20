## Technical Summary and Code Documentation

## Instructions for Create Brand, Create Schema, Create Template, Mint NFT

A common order of creating NFT would be

- Create Admin Account with `transaction/setupAdminAccount.cdc`.
- Owner then create that account as XGStudio-Admin and gives ability to create Brand, Schema and Template for XGStudio contract with `transactions/AddAdminAccount.cdc`
- Create new Brand with `transactions/createBrand.cdc` using Admin Account.
- Create new Schema with `transactions/createSchema.cdc` using Admin Account.
- Create new Template with `transactions/createTemplate.cdc` using Admin Account.
- Create NFT Receiver with `transaction/setupAccount.cdc`.
- Mint NFT with `transaction/mintNFT.cdc`.

You can also see the scripts in `scripts` to see how information
can be read from the XGStudio smart-contract.

### XGStudio Events

- Contract Initialized ->
  ` pub event ContractInitialized()`
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
| Testnet | `0xff321cc072da62b3` |

### Deployment Contract on Emulator

- Run `flow project deploy --network emulator`
  - All contracts are deployed to the emulator.

After the contracts have been deployed, you can run the sample transactions
to interact with the contracts. The sample transactions are meant to be used
in an automated context, so they use transaction arguments and string template
fields. These make it easier for a program to use and interact with them.
If you are running these transactions manually in the Flow Playground or
vscode extension, you will need to remove the transaction arguments and
hard code the values that they are used for.
