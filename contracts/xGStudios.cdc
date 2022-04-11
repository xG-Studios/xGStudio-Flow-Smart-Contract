import NonFungibleToken from 0xf8d6e0586b0a20c7
pub contract xGStudios:NonFungibleToken{

    pub var totalSupply:UInt64
   
     // Event that emitted when the NFT contract is initialized
    //
    pub event ContractInitialized()

    // If the collection is not in an account's storage, `from` will be `nil`.
    //
    pub event Withdraw(id: UInt64, from: Address?)

    // It indicates the owner of the collection that it was deposited to.
    //
    pub event Deposit(id: UInt64, to: Address?)

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

    pub resource NFTMinter{
        pub fun createNFT(): @NFT {
            return <- create NFT()
        }

        init(){
        
        }
    }
  
     pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    init(){
        self.totalSupply=0
        emit ContractInitialized()
        self.account.save(<- create NFTMinter(), to: /storage/Minter)
    }
}
 