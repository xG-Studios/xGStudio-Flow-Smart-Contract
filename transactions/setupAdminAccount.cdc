import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction() {
    prepare(signer: AuthAccount) {
        // save the resource to the signer's account storage
        if signer.getLinkTarget(xGStudios.NFTMethodsCapabilityPrivatePath) == nil {
            let adminResouce <- xGStudios.createAdminResource()
            signer.save(<- adminResouce, to: xGStudios.AdminResourceStoragePath)
            
            // link the UnlockedCapability in private storage
            signer.link<&{xGStudios.NFTMethodsCapability}>(
                xGStudios.NFTMethodsCapabilityPrivatePath,
                target: xGStudios.AdminResourceStoragePath
            )
        }

        signer.link<&{xGStudios.UserSpecialCapability}>(
            /public/UserSpecialCapability,
            target: xGStudios.AdminResourceStoragePath
        )

        let collection  <- xGStudios.createEmptyCollection()
        // store the empty NFT Collection in account storage
        signer.save( <- collection, to: xGStudios.CollectionStoragePath)
        // create a public capability for the Collection
        signer.link<&{xGStudios.MyCollectionPublic}>(xGStudios.CollectionPublicPath, target:xGStudios.CollectionStoragePath)
        log("ok")
    }
}