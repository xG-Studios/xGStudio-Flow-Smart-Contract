import XGStudio from "../contracts/XGStudio.cdc"

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
 