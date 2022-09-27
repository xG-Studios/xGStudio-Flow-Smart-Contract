import XGStudio from "../contracts/XGStudio.cdc"


transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        
        let immutableData : {String: AnyStruct} = {
            "contentType" : "Image",
            "contectUrl"  : "https://xgstudios.io",
            "title"       : "Second NFT",
            "title"       : "Win: Alexandra Park v Hilltop Women",
            "xGRewardType": "Win",
            "competition":"Greater London Women''s Football League",
            "fixtureType":"Division 2 North",
            "activityType":"Football",
            "season":"2022/23",
            "playerTeam":"Hilltop Women",
            "oppositionTeam":"Alexandra Park",
            "date":"04/09/2022",
            "venue":"A",
            "result":"W",
            "score":"0 - 16"
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
