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
            "extraContentClass": XGStudio.SchemaType.String,
            "extraContentType": XGStudio.SchemaType.String,
            "title"       : XGStudio.SchemaType.String,
            "subtitle"    : XGStudio.SchemaType.String,
            "description" : XGStudio.SchemaType.String,
            "nftClass"    : XGStudio.SchemaType.String,
            "nftType"     : XGStudio.SchemaType.String,
            "season"          : XGStudio.SchemaType.String,
            "activityType"    : XGStudio.SchemaType.String,
            "assetBackground" : XGStudio.SchemaType.String,
            "assetContent"    : XGStudio.SchemaType.String,
            "assetArtist"     : XGStudio.SchemaType.String,
            "thumbnail"       : XGStudio.SchemaType.String,
            "royalties"       : XGStudio.SchemaType.Array
            }

        actorResource.createSchema(schemaName: schemaName, format: format)
    }
}