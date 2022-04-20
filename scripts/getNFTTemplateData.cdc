import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae


pub fun main(address: Address) : {UInt64: AnyStruct}{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(xGStudios.CollectionPublicPath)
                            .borrow<&{xGStudios.xGStudiosCollectionPublic}>()
                            ??panic("could not borrow receiver reference ")

    var nftIds =   acct1Capability.getIDs()

    var dict : {UInt64: AnyStruct} = {}

    for nftId in nftIds {
        var nftData = xGStudios.getNFTDataById(nftId: nftId)
        var templateDataById =  xGStudios.getTemplateById(templateId: nftData.templateID)

        var nftMetaData : {String:AnyStruct} = {}
        
        nftMetaData["mintNumber"] =nftData.mintNumber;
        nftMetaData["templateData"] = templateDataById;
        dict.insert(key: nftId,nftMetaData)
    }
    return dict
}