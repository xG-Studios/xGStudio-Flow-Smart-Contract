import NonFungibleToken from 0xf8d6e0586b0a20c7
pub contract xGStudios:NonFungibleToken{

    // Events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event BrandCreated(brandId: UInt64, brandName: String, author: Address, data:{String: String})
    pub event BrandUpdated(brandId: UInt64, brandName: String, author: Address, data:{String: String})
    // Paths
    pub let AdminResourceStoragePath: StoragePath
    pub let NFTMethodsCapabilityPrivatePath: PrivatePath
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let AdminStorageCapability: StoragePath
    pub let AdminCapabilityPrivate: PrivatePath

    
    // Latest brand-id
    pub var lastIssuedBrandId: UInt64

    access(self) var allBrands: {UInt64: Brand}

    pub var totalSupply:UInt64


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

    pub resource interface NFTMethodsCapability{
        pub fun createNewBrand(brandName: String, data: {String: String}) 
        pub fun updateBrandData(brandId: UInt64, data: {String: String}) 
        pub fun createNFT(): @NFT
        pub fun logg()
    }

    pub resource AdminResource:NFTMethodsCapability,UserSpecialCapability{
      
 // a variable which stores all Brands owned by a user
        priv var ownedBrands: {UInt64: Brand}
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
     
        pub fun createNFT(): @NFT{
            return <- create NFT()
        }

        pub fun logg(){
            log("good")
        }

        init(){
            self.capability = nil
            self.ownedBrands={}
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

    init(){
        self.totalSupply=0
        self.lastIssuedBrandId = 1
        self.allBrands = {}
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
 