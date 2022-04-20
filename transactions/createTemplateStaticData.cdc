import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae


transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{xGStudios.NFTMethodsCapability}>
            (xGStudios.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")


        let nftType : [String] = ["1st-Positon-Male","2nd-Positon-Male","3rd-Positon-Male","Participant-Male",
                                "1st-Positon-Female","2nd-Positon-Female","3rd-Positon-Female","Participant-Female"]

        
        let immutableData : {String: AnyStruct} = {   
            "Content-Type" : "Image",
            "Content-URL"  : "https://troontechnologies.com/",
            "Title": "First NFT",
            "Description":  "bored ape brown",
            "NFT-Type":  nftType[5],
            "Race-Name":  "Lion",
            "Race-date":  "April 18",
            "Race-Description": "Lion race",     
            "maxSupply": 500
        }
        
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
