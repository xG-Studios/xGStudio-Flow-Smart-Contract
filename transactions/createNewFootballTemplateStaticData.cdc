import XGStudio from "../contracts/XGStudio.cdc"
import MetadataViews from "../contracts/MetadataViews.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import Profile from "../contracts/Profile.cdc"


transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        

        let artistVault = getAccount(0x2ce293d39a72a72b).getCapability<&{FungibleToken.Receiver}>(Profile.publicReceiverPath)
        let footballVault = getAccount(0xa6fa47e9ad815dcf).getCapability<&{FungibleToken.Receiver}>(Profile.publicReceiverPath)

        let royalties: [MetadataViews.Royalty] = footballVault.check() ? [
            MetadataViews.Royalty(
                receiver: footballVault,
                cut: 0.05,
                description: "xGFootball treasury"
            )
        ] : []
        // Only add receiver if the Profile capability exists
        if (artistVault.check()) {
            royalties.append(
                MetadataViews.Royalty(
                    receiver: artistVault,
                    cut: 0.025,
                    description: "Artist"
                )
            )
        }

        let immutableData : {String: AnyStruct} = {
            "contentType" : "mp4",
            "contentUrl"  : "QmPfCoGa6y8rTvjUcbL64h4MScKzjvy9Ta4fCX3pTxMMWX/xG_GENESIS_WIN_V2.mp4",
            "title"       : "new schema test title",
            "description" : "new schema test desc",
            "xGRewardType"     : "Appearance",
            "competition"    : "new schema test competition",
            "date"    : "today",
            "fixtureType"   : "new schema test fixture",
            "season" : "new schema test season",
            "activityType"   : "testing",
            "playerTeam" : "team A",
            "oppositionTeam" : "team B",
            "venue" : "new schmea test venue",
            "result" : "new schmea test result",
            "score" : "177 - 177",
            "thumbnail" : "QmSLgeFrVMv2q76YvuTcrbCpbdegm3kjDV33DWWMyDBhBh",
            "assetBackground" : "new schema test bg",
            "assetContent" : "new schema test content",
            "assetArtist" : "new schema test artist",
            "royalties" : royalties
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
