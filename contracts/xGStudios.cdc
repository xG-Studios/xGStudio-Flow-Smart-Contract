import NonFungibleToken from 0xf8d6e0586b0a20c7
pub contract xGStudios:NonFungibleToken{

   // Events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event NFTBorrowed(id: UInt64)
    pub event NFTDestroyed(id: UInt64)
    pub event NFTMinted(nftId: UInt64, templateId: UInt64, mintNumber: UInt64)
    pub event BrandCreated(brandId: UInt64, brandName: String, author: Address, data:{String: String})
    pub event BrandUpdated(brandId: UInt64, brandName: String, author: Address, data:{String: String})
    pub event SchemaCreated(schemaId: UInt64, schemaName: String, author: Address)
    pub event TemplateCreated(templateId: UInt64, brandId: UInt64, schemaId: UInt64, maxSupply: UInt64)
    pub event TemplateRemoved(templateId: UInt64)

    // Paths
    pub let AdminResourceStoragePath: StoragePath
    pub let NFTMethodsCapabilityPrivatePath: PrivatePath
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let AdminStorageCapability: StoragePath
    pub let AdminCapabilityPrivate: PrivatePath

    // Latest brand-id
    pub var lastIssuedBrandId: UInt64

    // Latest schema-id
    pub var lastIssuedSchemaId: UInt64

    // Latest Template-id
    pub var lastIssuedTemplateId: UInt64

    // Total supply of all NFTs that are minted using this contract
    pub var totalSupply: UInt64
    
    // A dictionary that stores all Brands against it's brand-id.
    access(self) var allBrands: {UInt64: Brand}
    access(self) var allSchemas: {UInt64: Schema}
    access(self) var allTemplates: {UInt64: Template}
    //access(self) var allNFTs: {UInt64: TroonAtomicNFTData}

    // Accounts ability to add capability
    access(self) var whiteListedAccounts: [Address]


 // A structure that contain all the data related to a Brand
    pub struct Brand {
        pub let brandId: UInt64
        pub let brandName: String
        pub let author: Address
        access(contract) var data: {String: String}
        
        init(brandName: String, author: Address, data: {String: String}) {
            pre {
                brandName.length > 0: "Brand name is required";
            }

            let newBrandId = xGStudios.lastIssuedBrandId
            self.brandId = newBrandId
            self.brandName = brandName
            self.author = author
            self.data = data
        }
        pub fun update(data: {String: String}) {
            self.data = data
        }
    }

// Create Schema Support all the mentioned Types
    pub enum SchemaType: UInt8 {
        pub case String
        pub case Int
        pub case Fix64
        pub case Bool
        pub case Address
        pub case Array
        pub case Any
    }

     // A structure that contain all the data related to a Schema
    pub struct Schema {
        pub let schemaId: UInt64
        pub let schemaName: String
        pub let author: Address
        access(contract) let format: {String: SchemaType}

        init(schemaName: String, author: Address, format: {String: SchemaType}){
            pre {
                schemaName.length > 0: "Could not create schema: name is required"
            }

            let newSchemaId = xGStudios.lastIssuedSchemaId
            self.schemaId = newSchemaId
            self.schemaName = schemaName
            self.author = author
            self.format = format
        }
    }

    // A structure that contain all the data and methods related to Template
    pub struct Template {
        pub let templateId: UInt64
        pub let brandId: UInt64
        pub let schemaId: UInt64
        pub var maxSupply: UInt64
        pub var issuedSupply: UInt64
        pub var immutableData: {String: AnyStruct}

        init(brandId: UInt64, schemaId: UInt64, maxSupply: UInt64, immutableData: {String: AnyStruct}) {
            pre {
                xGStudios.allBrands[brandId] != nil:"Brand Id must be valid"
                xGStudios.allSchemas[schemaId] != nil:"Schema Id must be valid"
                maxSupply > 0 : "MaxSupply must be greater than zero"
                immutableData != nil: "ImmutableData must not be nil"
            }

            self.templateId = xGStudios.lastIssuedTemplateId
            self.brandId = brandId
            self.schemaId = schemaId
            self.maxSupply = maxSupply
            self.immutableData = immutableData
            self.issuedSupply = 0
            // Before creating template, we need to check template data, if it is valid against given schema or not
            let schema = xGStudios.allSchemas[schemaId]!
            var invalidKey: String = ""
            var isValidTemplate = true

            for key in immutableData.keys {
                let value = immutableData[key]!
                if(schema.format[key] == nil) {
                    isValidTemplate = false
                    invalidKey = "key $".concat(key.concat(" not found"))
                    break
                }
                if schema.format[key] == xGStudios.SchemaType.String {
                    if(value as? String == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }
                else if schema.format[key] == xGStudios.SchemaType.Int {
                    if(value as? Int == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                } 
                else if schema.format[key] == xGStudios.SchemaType.Fix64 {
                    if(value as? Fix64 == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }else if schema.format[key] == xGStudios.SchemaType.Bool {
                    if(value as? Bool == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }else if schema.format[key] == xGStudios.SchemaType.Address {
                    if(value as? Address == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }
                else if schema.format[key] == xGStudios.SchemaType.Array {
                    if(value as? [AnyStruct] == nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }
                else if schema.format[key] == xGStudios.SchemaType.Any {
                    if(value as? {String:AnyStruct} ==nil) {
                        isValidTemplate = false
                        invalidKey = "key $".concat(key.concat(" has type mismatch"))
                        break
                    }
                }
            }
            assert(isValidTemplate, message: "invalid template data. Error: ".concat(invalidKey))

            
        }

        // a method to increment issued supply for template
        access(contract) fun incrementIssuedSupply(): UInt64 {
            pre {
                self.issuedSupply < self.maxSupply: "Template reached max supply"
            }   

            self.issuedSupply = self.issuedSupply + 1
            return self.issuedSupply
        }
    }

    pub resource NFT: NonFungibleToken.INFT{
        pub let id:UInt64
        pub var name:String

        init(){
            self.id=xGStudios.totalSupply
            xGStudios.totalSupply = xGStudios.totalSupply + (1 as UInt64)
            self.name = "Fahim"
        }
    }

    pub resource interface MyCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowEntireNFT(id: UInt64): &NFT
    }

    pub resource Collection:NonFungibleToken.Provider,NonFungibleToken.Receiver,NonFungibleToken.CollectionPublic,MyCollectionPublic{
        pub var ownedNFTs: @{UInt64:NonFungibleToken.NFT}

        pub fun deposit(token: @NonFungibleToken.NFT){
            let xGStudiosNFT <- token as! @NFT
            emit Deposit(id: xGStudiosNFT.id, to: self.owner?.address)
            self.ownedNFTs[xGStudiosNFT.id] <-! xGStudiosNFT
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT{
            pre{
                self.ownedNFTs.containsKey(withdrawID):"NFT with this ID doesn't exists"
            }
           let token <- self.ownedNFTs.remove(key:withdrawID)!
           emit Withdraw(id: withdrawID, from: self.owner?.address)
           return <- token
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
          return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        pub fun borrowEntireNFT(id: UInt64): &NFT {
        pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
          let refNFT = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
          return refNFT as! &NFT
        }

        pub fun getIDs(): [UInt64]{
            return self.ownedNFTs.keys
        }

        init(){
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs     
        }
    }

    pub resource interface UserSpecialCapability {
        pub fun addCapability(cap: Capability<&{NFTMethodsCapability}>) 
    }

   // Interface, which contains all the methods that are called by any user to mint NFT and manage brand, schema and template funtionality
    pub resource interface NFTMethodsCapability {
        pub fun createNewBrand(brandName: String, data: {String: String})
        pub fun updateBrandData(brandId: UInt64, data: {String: String})
        pub fun createSchema(schemaName: String, format: {String: SchemaType})
        pub fun createTemplate(brandId: UInt64, schemaId: UInt64, maxSupply: UInt64, immutableData: {String: AnyStruct})
        pub fun removeTemplateById(templateId: UInt64): Bool 
      //  pub fun mintNFT(templateId: UInt64, account: Address)
    }

    pub resource AdminResource:NFTMethodsCapability,UserSpecialCapability{
      
         // a variable which stores all Brands owned by a user
        priv var ownedBrands: {UInt64: Brand}
        // a variable which stores all Schema owned by a user
        priv var ownedSchemas: {UInt64: Schema}
        // a variable which stores all Templates owned by a user
        priv var ownedTemplates: {UInt64: Template}
        // a variable that store user capability to utilize methods 
        access(contract) var capability: Capability<&{NFTMethodsCapability}>?
        // method which provide capability to user to utilize methods
        pub fun addCapability(cap: Capability<&{NFTMethodsCapability}>) {
            pre {
                // we make sure the SpecialCapability is
                // valid before executing the method
                cap.borrow() != nil: "could not borrow a reference to the SpecialCapability"
                self.capability == nil: "resource already has the SpecialCapability"
                xGStudios.whiteListedAccounts.contains(self.owner!.address): "you are not authorized for this action"
            }
            // add the SpecialCapability
            self.capability = cap
        }

         //method to create new Brand, only access by the verified user
        pub fun createNewBrand(brandName: String, data: {String: String}) {
            pre {
                // the transaction will instantly revert if
                // the capability has not been added
                self.capability != nil: "I don't have the special capability :("
                xGStudios.whiteListedAccounts.contains(self.owner!.address): "you are not authorized for this action"
            }

            let newBrand = Brand(brandName: brandName, author: self.owner?.address!, data: data)
            xGStudios.allBrands[xGStudios.lastIssuedBrandId] = newBrand
            emit BrandCreated(brandId: xGStudios.lastIssuedBrandId ,brandName: brandName, author: self.owner?.address!, data: data)
            self.ownedBrands[xGStudios.lastIssuedBrandId] = newBrand 
            xGStudios.lastIssuedBrandId = xGStudios.lastIssuedBrandId + 1
        }

        //method to update the existing Brand, only author of brand can update this brand
        pub fun updateBrandData(brandId: UInt64, data: {String: String}) {
            pre{
                // the transaction will instantly revert if
                // the capability has not been added
                self.capability != nil: "I don't have the special capability :("
                xGStudios.whiteListedAccounts.contains(self.owner!.address): "you are not authorized for this action"
                xGStudios.allBrands[brandId] != nil: "brand Id does not exists"
            }

            let oldBrand = xGStudios.allBrands[brandId]
            if self.owner?.address! != oldBrand!.author {
                panic("No permission to update others brand")
            }

            xGStudios.allBrands[brandId]!.update(data: data)
            emit BrandUpdated(brandId: brandId, brandName: oldBrand!.brandName, author: oldBrand!.author, data: data)
        }

         //method to create new Schema, only access by the verified user
        pub fun createSchema(schemaName: String, format: {String: SchemaType}) {
            pre {
                // the transaction will instantly revert if 
                // the capability has not been added
                self.capability != nil: "I don't have the special capability :("
                xGStudios.whiteListedAccounts.contains(self.owner!.address): "you are not authorized for this action"
            }

            let newSchema = Schema(schemaName: schemaName, author: self.owner?.address!, format: format)
            xGStudios.allSchemas[xGStudios.lastIssuedSchemaId] = newSchema
            emit SchemaCreated(schemaId: xGStudios.lastIssuedSchemaId, schemaName: schemaName, author: self.owner?.address!)
            self.ownedSchemas[xGStudios.lastIssuedSchemaId] = newSchema
            xGStudios.lastIssuedSchemaId = xGStudios.lastIssuedSchemaId + 1
            
        }

         //method to create new Template, only access by the verified user
        pub fun createTemplate(brandId: UInt64, schemaId: UInt64, maxSupply: UInt64, immutableData: {String: AnyStruct}) {
            pre { 
                // the transaction will instantly revert if 
                // the capability has not been added
                self.capability != nil: "I don't have the special capability :("
                xGStudios.whiteListedAccounts.contains(self.owner!.address): "you are not authorized for this action"
                self.ownedBrands[brandId] != nil: "Collection Id Must be valid"
                self.ownedSchemas[schemaId] != nil: "Schema Id Must be valid"
            }

            let newTemplate = Template(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
            xGStudios.allTemplates[xGStudios.lastIssuedTemplateId] = newTemplate
            emit TemplateCreated(templateId: xGStudios.lastIssuedTemplateId, brandId: brandId, schemaId: schemaId, maxSupply: maxSupply)
            self.ownedTemplates[xGStudios.lastIssuedTemplateId] = newTemplate
            xGStudios.lastIssuedTemplateId = xGStudios.lastIssuedTemplateId + 1
        }

         //method to remove template by id
        pub fun removeTemplateById(templateId: UInt64): Bool {
            pre {
                templateId != nil: "invalid template id"
                xGStudios.allTemplates[templateId]!=nil: "template id does not exist"
                xGStudios.allTemplates[templateId]!.issuedSupply == 0: "could not remove template with given id"   
            }
            let mintsData =  xGStudios.allTemplates.remove(key: templateId)
            emit TemplateRemoved(templateId: templateId)
            return true
        }

     
        pub fun createNFT(): @NFT{
            return <- create NFT()
        }

        pub fun logg(){
            log("good")
        }

        init(){
            self.ownedBrands = {}
            self.ownedSchemas = {}
            self.ownedTemplates = {}
            self.capability = nil
        }
    }

     //AdminCapability to add whiteListedAccounts
     pub resource AdminCapability{
        
        pub fun addwhiteListedAccount(_user: Address) {
            pre{
                xGStudios.whiteListedAccounts.contains(_user) == false: "user already exist"
            }
            xGStudios.whiteListedAccounts.append(_user)
        }

        pub fun isWhiteListedAccount(_user: Address): Bool {
            return xGStudios.whiteListedAccounts.contains(_user)
        }

        init(){}
    }


   pub fun createAdminResource(): @AdminResource {
           return <- create AdminResource()
     }

     pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }
    //method to get all brands
    pub fun getAllBrands(): {UInt64: Brand} {
        return xGStudios.allBrands
    }

     //method to get brand by id
    pub fun getBrandById(brandId: UInt64): Brand {
        pre {
            xGStudios.allBrands[brandId] != nil: "brand Id does not exists"
        }
        return xGStudios.allBrands[brandId]!
    }

     //method to get all schema
    pub fun getAllSchemas(): {UInt64: Schema} {
        return xGStudios.allSchemas
    }

    //method to get schema by id
    pub fun getSchemaById(schemaId: UInt64): Schema {
        pre {
            xGStudios.allSchemas[schemaId] != nil: "schema id does not exist"
        }
        return xGStudios.allSchemas[schemaId]!
    }

    //method to get all templates
    pub fun getAllTemplates(): {UInt64: Template} {
        return xGStudios.allTemplates
    }

    //method to get template by id
    pub fun getTemplateById(templateId: UInt64): Template {
        pre {
            xGStudios.allTemplates[templateId]!=nil: "Template id does not exist"
        }
        return xGStudios.allTemplates[templateId]!
    } 


    //Initialize all variables with default values
    init(){
        self.lastIssuedBrandId = 1
        self.lastIssuedSchemaId = 1
        self.lastIssuedTemplateId = 1
        self.totalSupply = 0
        self.allBrands = {}
        self.allSchemas = {}
        self.allTemplates = {}
        //self.allNFTs = {}
        self.whiteListedAccounts = [self.account.address]

        self.AdminResourceStoragePath = /storage/TroonAdminResourcev01
        self.CollectionStoragePath = /storage/TroonCollectionv01
        self.CollectionPublicPath = /public/TroonCollectionv01
        self.AdminStorageCapability = /storage/AdminCapability
        self.AdminCapabilityPrivate = /private/AdminCapability
        self.NFTMethodsCapabilityPrivatePath = /private/NFTMethodsCapabilityv01
        
        self.account.save<@AdminCapability>(<- create AdminCapability(), to: /storage/AdminStorageCapability)
        self.account.link<&AdminCapability>(self.AdminCapabilityPrivate, target: /storage/AdminStorageCapability)

        
        self.account.save<@AdminResource>(<- create AdminResource(), to: self.AdminResourceStoragePath)
        self.account.link<&{NFTMethodsCapability}>(self.NFTMethodsCapabilityPrivatePath, target: self.AdminResourceStoragePath)

        emit ContractInitialized()
    }
}