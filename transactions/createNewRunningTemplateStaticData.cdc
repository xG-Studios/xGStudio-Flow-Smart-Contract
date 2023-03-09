import XGStudio from "../contracts/XGStudio.cdc"
import MetadataViews from "../contracts/MetadataViews.cdc"

transaction(brandId:UInt64, schemaId:UInt64, maxSupply:UInt64) {
    prepare(acct: AuthAccount) {

        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        
        let immutableData : {String: AnyStruct} = {
            "contentType" : "mp4",
            "contentUrl"  : "QmPfCoGa6y8rTvjUcbL64h4MScKzjvy9Ta4fCX3pTxMMWX/xG_GENESIS_WIN_V2.mp4",
            "title"       : "new schema test",
            "description" : "new schema test",
            "nftType"     : "new schema test type",
            "raceName"    : "new schema test",
            "raceDate"    : "today",
            "raceDescription"   : "new schema test",
            "raceLocation" : "new schema test loc",
            "activityType"   : "testing",
            "distance" : "0M",
            "thumbnail" : "QmSLgeFrVMv2q76YvuTcrbCpbdegm3kjDV33DWWMyDBhBh",
            "assetBackground" : "new schema test bg",
            "assetContent" : "new schema test content",
            "assetArtist" : "new schema test artist",
            "royalties" : []
        }
        actorResource.createTemplate(brandId: brandId, schemaId: schemaId, maxSupply: maxSupply, immutableData: immutableData)
        log("Template created")
    }
}
