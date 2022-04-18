import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64,immutableData:{String: AnyStruct}) {
     prepare(acct: AuthAccount) {

       let actorResource = acct.getCapability
            <&{xGStudios.NFTMethodsCapability}>
            (xGStudios.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")

        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
    }
}