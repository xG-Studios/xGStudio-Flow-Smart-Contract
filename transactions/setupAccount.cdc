import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7


transaction() {
    prepare(acct: AuthAccount) {

        let collection  <- xGStudios.createEmptyCollection()
        // store the empty NFT Collection in account storage
        acct.save( <- collection, to:xGStudios.CollectionStoragePath)
        log("Collection created for account".concat(acct.address.toString()))
        // create a public capability for the Collection
        acct.link<&{xGStudios.xGStudiosCollectionPublic}>(xGStudios.CollectionPublicPath, target:xGStudios.CollectionStoragePath)
        
    }
}