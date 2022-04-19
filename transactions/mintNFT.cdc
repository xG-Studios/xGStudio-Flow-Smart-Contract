import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction(templateId: UInt64, account:Address){

    prepare(acct: AuthAccount) {
        let actorResource = acct.getCapability
        <&{xGStudios.NFTMethodsCapability}>
        (xGStudios.NFTMethodsCapabilityPrivatePath)
        .borrow() ?? 
        panic("could not borrow a reference to the NFTMethodsCapability interface")
        actorResource.mintNFT(templateId: templateId, account: account) 
    }

}

