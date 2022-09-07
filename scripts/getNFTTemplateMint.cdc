import XGStudio from "../contracts/XGStudio.cdc"

pub fun main(address: Address) : [{String:AnyStruct}]{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(XGStudio.CollectionPublicPath)
                            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
                            ??panic("could not borrow receiver reference ")

    var nftIds =   acct1Capability.getIDs()

    var arr : [{String:AnyStruct}] = []
    

    for nftId in nftIds {
        var nftData = XGStudio.getNFTDataById(nftId: nftId)
        var templateData =  XGStudio.getTemplateById(templateId: nftData.templateID)

        var immutableData = nftData.getImmutableData()

        var nftMetaData : {String:AnyStruct} = {}
        nftMetaData["templateId"] =nftData.templateID;
        nftMetaData["mintNumber"] =nftData.mintNumber;
        nftMetaData["immutableData"] =immutableData;


        arr.append(nftMetaData)
    }
    return arr

}