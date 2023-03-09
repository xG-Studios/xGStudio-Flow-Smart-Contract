import XGStudio from "../contracts/XGStudio.cdc"

transaction(templateId: UInt64, account:Address, name: String){

    prepare(acct: AuthAccount) {
        let actorResource = acct.getCapability
        <&{XGStudio.NFTMethodsCapability}>
        (XGStudio.NFTMethodsCapabilityPrivatePath)
        .borrow() ?? 
        panic("could not borrow a reference to the NFTMethodsCapability interface")
        let immutableData : {String: AnyStruct} = {
            "name" : name  
        }
        actorResource.mintNFT(templateId: templateId, account: account, immutableData:immutableData) 
    }
    execute{
        log("nft minted")
    }
}
