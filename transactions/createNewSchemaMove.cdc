import XGStudio from "../contracts/XGStudio.cdc"
import MetadataViews from "../contracts/MetadataViews.cdc"


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
            "description" : XGStudio.SchemaType.String,
            "nftType"     : XGStudio.SchemaType.String,
            "raceName"    : XGStudio.SchemaType.String,
            "raceDate"    : XGStudio.SchemaType.String,
            "raceDescription"   : XGStudio.SchemaType.String,
            "raceLocation" :XGStudio.SchemaType.String,
            "activityType"   : XGStudio.SchemaType.String,
            "distance" :XGStudio.SchemaType.String,
            "thumbnail" : XGStudio.SchemaType.String,
            "assetBackground" : XGStudio.SchemaType.String,
            "assetContent" : XGStudio.SchemaType.String,
            "assetArtist" : XGStudio.SchemaType.String,
            "royalties" : XGStudio.SchemaType.Array
            }

        actorResource.createSchema(schemaName: schemaName, format: format)
    }
}
 