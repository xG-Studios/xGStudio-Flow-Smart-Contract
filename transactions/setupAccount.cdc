import XGStudio from 0xc357c8d061353f5f

transaction {
    prepare(acct: AuthAccount) {

        let collection  <- XGStudio.createEmptyCollection()
        // store the empty NFT Collection in account storage
        acct.save( <- collection, to:XGStudio.CollectionStoragePath)
        log("Collection created for account".concat(acct.address.toString()))
        // create a public capability for the Collection
        acct.link<&{XGStudio.XGStudioCollectionPublic}>(XGStudio.CollectionPublicPath, target:XGStudio.CollectionStoragePath)        
    }
}