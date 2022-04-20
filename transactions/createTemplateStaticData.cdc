import XGStudio from 0xff321cc072da62b3

transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        
        let immutableData : {String: AnyStruct} = {
            "contectType" : "Image",
            "contectUrl"  : "https://xgstudios.io",
            "title"       : "Second NFT",
            "description" : "Second NFT for the xgStudio",
            "nftType"     : "AR",
            "raceName"    : "Lion",
            "raceDate":  1649994582.0 as Fix64,
            "raceDescription": "Lion race"     
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}