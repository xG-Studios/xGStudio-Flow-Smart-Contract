import XGStudio from 0xc357c8d061353f5f

pub fun main(address: Address) : {UInt64: AnyStruct}{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(XGStudio.CollectionPublicPath)
                            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
                            ??panic("could not borrow receiver reference ")

    var nftIds =   acct1Capability.getIDs()

    var dict : {UInt64: AnyStruct} = {}

    for nftId in nftIds {
        var nftData = XGStudio.getNFTDataById(nftId: nftId)
        var templateData =  XGStudio.getTemplateById(templateId: nftData.templateID)

        var nftMetaData : {String:AnyStruct} = {}
        
        nftMetaData["templateData"] = templateData;
        nftMetaData["nftData"] =  nftData
        dict.insert(key: nftId,nftMetaData)
    }
    return dict
}