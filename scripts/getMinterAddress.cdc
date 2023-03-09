import XGStudio from "../contracts/XGStudio.cdc"

pub fun main(nftId: UInt64 ) : Address {
    
    var nftData = XGStudio.getNFTDataById(nftId: nftId)
    var templateData =  XGStudio.getTemplateById(templateId: nftData.templateID)
    var nftImmutableData = nftData.getImmutableData()
    
    var nftMetaData : {String:AnyStruct} = {}
    


    return Address((nftImmutableData["minterAddress"] as! Int?) ?? 0)
}