import XGStudio from 0xff321cc072da62b3

transaction (schemaName:String){

   prepare(acct: AuthAccount) {
      let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")

        let format : {String: XGStudio.SchemaType} = {
            "contectType" : XGStudio.SchemaType.String,
            "contectUrl"  : XGStudio.SchemaType.String,
            "title"       : XGStudio.SchemaType.String,
            "description" : XGStudio.SchemaType.String,
            "nftType"     : XGStudio.SchemaType.String,
            "raceName"    : XGStudio.SchemaType.String,
            "raceDate"    : XGStudio.SchemaType.Fix64,
            "raceDescription"   : XGStudio.SchemaType.String
            }

        actorResource.createSchema(schemaName: schemaName, format: format)
    }
}