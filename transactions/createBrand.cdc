import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae


transaction (brandName:String, data:{String:String}){
    prepare(acct: AuthAccount) {
        let actorResource = acct.getCapability
            <&{xGStudios.NFTMethodsCapability}>
            (xGStudios.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")


       actorResource.createNewBrand(brandName: brandName,data: data)
    log("brand created")
    }
}