import XGStudio from "../contracts/XGStudio.cdc"

transaction (schemaName:String){

   prepare(acct: AuthAccount) {
      let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")

        let format : {String: XGStudio.SchemaType} = {
            "contentType" : XGStudio.SchemaType.String,
            "contentUrl"  : XGStudio.SchemaType.String,
            "title"       : XGStudio.SchemaType.String,
            "xGRewardType": XGStudio.SchemaType.String,
            "competition": XGStudio.SchemaType.String,
            "fixtureType": XGStudio.SchemaType.String,
            "activityType": XGStudio.SchemaType.String,
            "season": XGStudio.SchemaType.String,
            "playerTeam": XGStudio.SchemaType.String,
            "oppositionTeam": XGStudio.SchemaType.String,
            "date": XGStudio.SchemaType.String,
            "venue": XGStudio.SchemaType.String,
            "result": XGStudio.SchemaType.String,
            "score": XGStudio.SchemaType.String
            }

        actorResource.createSchema(schemaName: schemaName, format: format)
    }
}