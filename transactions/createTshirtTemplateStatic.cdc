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
        

        let footballVault = getAccount(0xa6fa47e9ad815dcf).getCapability<&{FungibleToken.Receiver}>(Profile.publicReceiverPath)

        let royalties: [MetadataViews.Royalty] = footballVault.check() ? [
            MetadataViews.Royalty(
                receiver: footballVault,
                cut: 0.05,
                description: "xGFootball treasury"
            )
        ] : []


        let immutableData : {String: AnyStruct} = {
            "contentType" : "mp4",
            "contentUrl"  : "QmYs7Hxy4Xsp3kLrqcTKn8duDwo7iQTjLUj4jZxYqXzENx/TShirtHIlltopMaleWhite.mp4",
            "extraContentClass": "Digital Kit Item",
            "extraContentType": "Football Shirt",
            "title"       : "Hilltop Men’s Home Shirt 2022/23",
            "subtitle"    : "Limited Edition xG Hilltop",
            "description" : "For players who make an appearance for the Club during the 2022/23 season. Quest Reward one of three.",
            "nftClass"    : "Milestone Reward",
            "nftType"     : "1 Appearance",
            "season"          : "2022/23",
            "activityType"    : "Football",
            "assetBackground" : "Black",
            "assetContent"    : "3D Football Shirt",
            "assetArtist"     : "xG Studios",
            "thumbnail"       : "QmYs7Hxy4Xsp3kLrqcTKn8duDwo7iQTjLUj4jZxYqXzENx/THUMB_TShirtHIlltopMaleWhite.png",
            "royalties"       : royalties
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
