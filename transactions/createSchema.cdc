import XGStudio from 0xd9575c84a88eada0

transaction (schemaName:String){

   prepare(acct: AuthAccount) {
      let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")

        let format : {String: XGStudio.SchemaType} = {
            "contentType" : XGStudio.SchemaType.String,
            "contectUrl"  : XGStudio.SchemaType.String,
            "title"       : XGStudio.SchemaType.String,
            "description" : XGStudio.SchemaType.String,
            "nftType"     : XGStudio.SchemaType.String,
            "gender"      : XGStudio.SchemaType.String,
            "raceName"    : XGStudio.SchemaType.String,
            "raceDate"    : XGStudio.SchemaType.Fix64,
            "raceDescription"   : XGStudio.SchemaType.String,
            "raceLocation" :XGStudio.SchemaType.String,
            "activityType"   : XGStudio.SchemaType.String,
            "distance" :XGStudio.SchemaType.Fix64
            }

        actorResource.createSchema(schemaName: schemaName, format: format)
    }
}