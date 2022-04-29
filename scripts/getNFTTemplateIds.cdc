import XGStudio from 0xff321cc072da62b3

pub fun main(address: Address) : [UInt64]{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(XGStudio.CollectionPublicPath)
                            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
                            ??panic("could not borrow receiver reference ")

    var nftIds =   acct1Capability.getIDs()

    var nftTemplateIds : [UInt64] = []

    for nftId in nftIds {
        var nftData = XGStudio.getNFTDataById(nftId: nftId)
        var templateDataById =  XGStudio.getTemplateById(templateId: nftData.templateID)

        nftTemplateIds.append(templateDataById.templateId)
    }
    return nftTemplateIds
}