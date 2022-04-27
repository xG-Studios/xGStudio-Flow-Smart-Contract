import XGStudio from 0xff321cc072da62b3

pub fun main(address: Address) : [{String:UInt64}]{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(XGStudio.CollectionPublicPath)
                            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
                            ??panic("could not borrow receiver reference ")

    var nftIds =   acct1Capability.getIDs()

    var arr : [{String:UInt64}] = []
    

    for nftId in nftIds {
        var nftData = XGStudio.getNFTDataById(nftId: nftId)
        var templateDataById =  XGStudio.getTemplateById(templateId: nftData.templateID)

        var nftMetaData : {String:UInt64} = {}
        nftMetaData["templateId"] =nftData.templateID;
        nftMetaData["mintNumber"] =nftData.mintNumber;

        arr.append(nftMetaData)
    }
    return arr

}