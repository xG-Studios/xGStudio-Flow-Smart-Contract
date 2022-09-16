import XGStudio from "../contracts/XGStudio.cdc"

transaction() {
    prepare(signer: AuthAccount) {
        // save the resource to the signer's account storage
        if signer.getLinkTarget(XGStudio.NFTMethodsCapabilityPrivatePath) == nil {
            let adminResouce <- XGStudio.createAdminResource()
            signer.save(<- adminResouce, to: XGStudio.AdminResourceStoragePath)
            // link the UnlockedCapability in private storage
            signer.link<&{XGStudio.NFTMethodsCapability}>(
                XGStudio.NFTMethodsCapabilityPrivatePath,
                target: XGStudio.AdminResourceStoragePath
            )
        }

        signer.link<&{XGStudio.UserSpecialCapability}>(
            /public/UserSpecialCapability,
            target: XGStudio.AdminResourceStoragePath
        )

        let collection  <- XGStudio.createEmptyCollection()
        // store the empty NFT Collection in account storage
        signer.save( <- collection, to: XGStudio.CollectionStoragePath)
        // create a public capability for the Collection
        signer.link<&{XGStudio.XGStudioCollectionPublic}>(XGStudio.CollectionPublicPath, target:XGStudio.CollectionStoragePath)
        log("ok")
    }
}