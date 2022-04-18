import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7


transaction (schemaName:String){

   prepare(acct: AuthAccount) {
      let actorResource = acct.getCapability
            <&{xGStudios.NFTMethodsCapability}>
            (xGStudios.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")

         let format : {String: xGStudios.SchemaType} = {
            "Content-Type" : xGStudios.SchemaType.String,
            "Content-URL"  :  xGStudios.SchemaType.String,
            "Title":xGStudios.SchemaType.String,
            "Description":  xGStudios.SchemaType.String,
            "NFT-Type":  xGStudios.SchemaType.String,
            "Race-Name":  xGStudios.SchemaType.String,
            "Race-date":  xGStudios.SchemaType.String,
            "Race-Description":  xGStudios.SchemaType.String,
            "maxSupply": xGStudios.SchemaType.Int
            }

         actorResource.createSchema(schemaName: schemaName, format: format)
   }
}