import XGStudio from "../../../contracts/XGStudio.cdc"

transaction() {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
             
            let immutableData : {String: AnyStruct} = {
                "contentType" : "mp4",
                "contentUrl"  : "QmPfCoGa6y8rTvjUcbL64h4MScKzjvy9Ta4fCX3pTxMMWX/xG_GENESIS_GOAL.mp4",
                "title"       : "Goal Scored: Hilltop 1 - 3 Wallingford & Crowmarsh",
                "xGRewardType": "Goal Scored",
                "competition":"Cherry Red Records Combined Counties Football League",
                "fixtureType":"Premier Division North",
                "activityType":"Football",
                "season":"2022/23",
                "playerTeam":"Hilltop",
                "oppositionTeam":"Wallingford & Crowmarsh",
                "date":"29/10/2022",
                "venue":"H",
                "result":"L",
                "score":"1 - 3"
            }
        actorResource.createTemplate(brandId:2, schemaId:2, maxSupply:1, immutableData: immutableData)
        log("Template created")
    }
}
 