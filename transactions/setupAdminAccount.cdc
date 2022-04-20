import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae

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
        signer.link<&{xGStudios.xGStudiosCollectionPublic}>(xGStudios.CollectionPublicPath, target:xGStudios.CollectionStoragePath)
        log("ok")
    }
}