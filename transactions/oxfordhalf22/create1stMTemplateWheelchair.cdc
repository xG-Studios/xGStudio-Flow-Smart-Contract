import XGStudio from "../../contracts/XGStudio.cdc"
import MetadataViews from "../../contracts/MetadataViews.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import Profile from "../../contracts/Profile.cdc"

transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        
        let artistVault = getAccount(0x2ce293d39a72a72b).getCapability<&{FungibleToken.Receiver}>(Profile.publicReceiverPath)
        let moveVault = getAccount(0xc2307c44b0903e33).getCapability<&{FungibleToken.Receiver}>(Profile.publicReceiverPath)

        let royalties: [MetadataViews.Royalty] = moveVault.check() ? [
            MetadataViews.Royalty(
                receiver: moveVault,
                cut: 0.05,
                description: "xGMove treasury"
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
            "contentUrl"  : "QmRrChrxQGGhRHT84QgYQgtE2ZivpxCxjzf5Ev2SeJg8zR/xG_podium_first_place_Oxford_half.mp4",
            "title"       : "1st - OXFORD HALF 2022",
            "description" : "1st Place xG Reward NFT. Presented at the Oxford Half by LimeLight and xG.",
            "nftType"     : "1stM",
            "raceName"    : "Oxford Half 2022",
            "raceDate"    : "2022-10-16",
            "raceDescription"   : "A race through historic streets and University Parks in the city of dreaming spires. The course is flat, passing the River Cherwell and Lady Margaret Hall, with live entertainment at every mile.",
            "raceLocation" : "Oxford, UK",
            "activityType"   : "Wheelchair Racing",
            "distance" : "21K",
            "thumbnail" : "QmNuWvD9LzJGtJf2tZfHHSsHYMyUbn2HWh7KRDSCrbcaB9/xG_podium_first_place_Oxford_half_THUMB.png",
            "assetBackground" : "xG Black Circular Podium",
            "assetContent" : "Grey Speckled Podium Loop: Gold 1st Place",
            "assetArtist" : "Hugo Boesch, Future Romance",
            "royalties" : royalties
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
