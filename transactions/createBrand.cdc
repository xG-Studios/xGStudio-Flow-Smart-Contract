import XGStudio from "../contracts/XGStudio.cdc"

// let data  : {String:String} = {
//             "name":"XGStudio",
//             "description":"xG® rewards athletes’ real world sports participation with personalised digital collectibles and the xG® utility token.",
//             "url":"https://xgstudios.io"   
//         }
transaction (brandName:String){
    prepare(acct: AuthAccount) {
        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow()
            ??panic("could not borrow a reference to the NFTMethodsCapability interface")
            let data  : {String:String} = {
                "name":"XGStudio",
                "description":"xG® rewards athletes’ real world sports participation with personalised digital collectibles and the xG® utility token.",
                "url":"https://xgstudios.io",
                "squareUrl": "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_THUMBNAIL.png", 
                "bannerUrl": "https://xgstudios.mypinata.cloud/ipfs/QmZP32SFcQ2rN2diEXsnwyFxZ5dmyFhuqAybDRANg2cEsk/XG_MOVE_COLLECTION_BANNER.png",
                "discord": "https://discord.com/invite/uaYhFARqXM", 
                "instagram": "https://www.instagram.com/xGStudios_/", 
                "twitter": "https://twitter.com/xGStudios_"
            }
        actorResource.createNewBrand(
            brandName: brandName,
            data: data)
            log("brand created:")
    
    }
}