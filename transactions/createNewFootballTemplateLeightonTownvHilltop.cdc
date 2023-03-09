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
            "contentUrl"  : "QmPfCoGa6y8rTvjUcbL64h4MScKzjvy9Ta4fCX3pTxMMWX/xG_GENESIS_PARTICIPATION.mp4",
            "title"       : "Appearance: Leighton Town 5 - 0 Hilltop",
            "description" : "Appearance: The xG Reward for players with game time in a fixture.\n\nGet xG Rewards for your football achievements.\nBuild your collection - your story.\nUnlock xG experiences.\n\nhttps://xgstudios.io",
            "xGRewardType": "Appearance",
            "competition"    : "Isuzu FA Vase",
            "date"    : "24/09/2022",
            "fixtureType"   : "Second Round Qualifying",
            "season" : "2022/23",
            "activityType"   : "Football",
            "playerTeam" : "Hilltop",
            "oppositionTeam" : "Leighton Town",
            "venue" : "A",
            "result" : "L",
            "score" : "5 - 0",
            "thumbnail" : "QmdxB4QPv5Ap59hDJfPxwUhwhNg8zH6mHVEV3TJbA61Zfh",
            "assetBackground" : "Black",
            "assetContent" : "Genesis Appearance Crystal",
            "assetArtist" : "Hugo Boesch, Future Romance",
            "royalties" : royalties
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
 