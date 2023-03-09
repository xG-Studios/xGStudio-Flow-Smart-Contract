import XGStudio from "../../../contracts/XGStudio.cdc"
import MetadataViews from "../../../contracts/MetadataViews.cdc"
import FungibleToken from "../../../contracts/FungibleToken.cdc"
import Profile from "../../../contracts/Profile.cdc"

transaction() {
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
                "title": "Appearance: London Lions 1 - 3 Hilltop",  
                "description" : "Appearance: The xG Reward for players with game time in a fixture.\n\nGet xG Rewards for your football achievements.\nBuild your collection - your story.\nUnlock xG experiences.\n\nhttps://linktr.ee/xgstudios",
                "xGRewardType": "Appearance",
                "competition"    : "Cherry Red Records Combined Counties Football League",
                "date"    : "05/11/2022",
                "fixtureType"   : "Premier Division North",
                "season" : "2022/23",
                "activityType"   : "Football",
                "playerTeam" : "Hilltop",
                "oppositionTeam" : "London Lions",
                "venue" : "A",
                "result" : "W",
                "score" : "1 - 3",
                "thumbnail" : "QmSPFN7uaUaW1H9GsET9HHKudMCLvB5JyFDPxyQ4FoGd5k/APPEARANCE.png",
                "assetBackground" : "Black",
                "assetContent" : "Genesis Appearance",
                "assetArtist" : "Hugo Boesch, Future Romance",
                "royalties" : royalties
                
               
            }
        actorResource.createTemplate(brandId:2, schemaId:5, maxSupply:15, immutableData: immutableData)
        log("Template created")
    }
}
