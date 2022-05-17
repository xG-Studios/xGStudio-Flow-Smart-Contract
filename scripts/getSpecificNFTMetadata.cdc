import XGStudio from 0xc357c8d061353f5f

pub fun main(nftId: UInt64 ) : {String:AnyStruct}{
    
    var nftData = XGStudio.getNFTDataById(nftId: nftId)
    var templateData =  XGStudio.getTemplateById(templateId: nftData.templateID)
    var nftImmutableData = nftData.getImmutableData()
    
    var nftMetaData : {String:AnyStruct} = {}
    
    nftMetaData["brandId"] =templateData.brandId;
    nftMetaData["schemaId"] =templateData.schemaId;
    nftMetaData["templateId"] =templateData.templateId;
    nftMetaData["mintNumber"] =nftData.mintNumber;
    nftMetaData["templateData"] =templateData.getImmutableData();
    nftMetaData["nftData"] =nftImmutableData;

    return nftMetaData
}