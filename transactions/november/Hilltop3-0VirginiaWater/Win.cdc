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
                "contentUrl"  : "QmPfCoGa6y8rTvjUcbL64h4MScKzjvy9Ta4fCX3pTxMMWX/xG_GENESIS_WIN_V2.mp4",
                "title": "Win: Hilltop 3 - 0 Virginia Water",  
                "description" : "Win: The xG Reward for players who made an appearance in a win.\n\nGet xG Rewards for your football achievements.\nBuild your collection - your story.\nUnlock xG experiences.\n\nhttps://linktr.ee/xgstudios",
                "xGRewardType": "Win",
                "competition"    : "Cherry Red Records Combined Counties Football League",
                "date"    : "12/11/2022",
                "fixtureType"   : "Premier Division North",
                "season" : "2022/23",
                "activityType"   : "Football",
                "playerTeam" : "Hilltop",
                "oppositionTeam" : "Virginia Water",
                "venue" : "H",
                "result" : "W",
                "score" : "3 - 0",
                "thumbnail" : "QmSPFN7uaUaW1H9GsET9HHKudMCLvB5JyFDPxyQ4FoGd5k/WIN.png",
                "assetBackground" : "Black",
                "assetContent" : "Genesis Win",
                "assetArtist" : "Hugo Boesch, Future Romance",
                "royalties" : royalties
                
               
            }
        actorResource.createTemplate(brandId:2, schemaId:5, maxSupply:16, immutableData: immutableData)
        log("Template created")
    }
}
 